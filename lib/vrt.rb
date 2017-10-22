# The 'guts' of the VRT library. Probably in need of refactoring in future.
# Will do file I/O the first time it's accessed, and will thereafter hold
# VRT versions in-memory.

require 'vrt/map'
require 'vrt/node'
require 'vrt/mapping'
require 'vrt/cross_version_mapping'

require 'date'
require 'json'
require 'pathname'

module VRT
  DIR = Pathname.new(__dir__).join('data')
  OTHER_OPTION = { 'id' => 'other',
                   'name' => 'Other',
                   'priority' => nil,
                   'type' => 'category' }.freeze
  MAPPINGS = %i[cvss_v3].freeze

  @version_json = {}
  @last_update = {}

  module_function

  extend CrossVersionMapping

  # Infer the available versions of the VRT from the names of the files
  # in the repo.
  # The returned list is in semver order with the current version first.
  def versions
    @versions ||= json_dir_names.sort_by { |v| Gem::Version.new(v) }.reverse!
  end

  # Get the most recent version of the VRT.
  def current_version
    versions.first
  end

  def current_version?(version)
    version == current_version
  end

  # Get the last updated timestamp of the VRT data (not schema!)
  # Passing nil for version will return the latest version.
  def last_updated(version = nil)
    version ||= current_version
    return @last_update[version] if @last_update[version]
    metadata = JSON.parse(json_pathname(version).read)['metadata']
    @last_update[version] = Date.parse(metadata['release_date'])
  end

  def current_categories
    Map.new(current_version).categories
  end

  # Get all deprecated ids that would match in the given categories from the current version
  def all_matching_categories(categories)
    cross_version_category_mapping.select { |key, _value| categories.include?(key) }.values.flatten
  end

  # Finds the best match valid node. First looks at valid nodes in the given new version or finds
  # the appropriate deprecated mapping. If neither is found it will walk up the tree to find a
  # valid parent node before giving up and returning nil.
  #
  # @param [String] vrt_id A valid vrt_id
  # @param [string] preferred_version (Optional) The preferred vrt_version of the returned node
  #   (defaults to current_version)
  # @param [String] max_depth (Optional) The maximum depth to match in
  # @param [String] version (deprecated) This parameter is no longer used
  # @return [VRT::Node|Nil] A valid VRT::Node object or nil if no best match could be found
  def find_node(vrt_id:, preferred_version: nil, max_depth: 'variant', version: nil) # rubocop:disable Lint/UnusedMethodArgument
    new_version = preferred_version || current_version
    if Map.new(new_version).valid?(vrt_id)
      Map.new(new_version).find_node(vrt_id, max_depth: max_depth)
    elsif deprecated_node?(vrt_id)
      find_deprecated_node(vrt_id, preferred_version, max_depth)
    else
      find_valid_parent_node(vrt_id, new_version, max_depth)
    end
  end

  # Load the VRT from text files, and parse it as JSON.
  # If other: true, we append the OTHER_OPTION hash at runtime (not cached)
  def get_json(version: nil, other: true)
    version ||= current_version
    @version_json[version] ||= json_for_version(version)
    other ? @version_json[version] + [OTHER_OPTION] : @version_json[version]
  end

  # Get names of directories matching lib/data/<major>-<minor>/
  def json_dir_names
    DIR.entries
       .map(&:basename)
       .map(&:to_s)
       .select { |dirname| dirname =~ /^[0-9]+\.[0-9]/ }.sort
  end

  # Get the Pathname for a particular version
  def json_pathname(version)
    DIR.join(version, 'vulnerability-rating-taxonomy.json')
  end

  # Load and parse JSON for some VRT version
  def json_for_version(version)
    JSON.parse(json_pathname(version).read)['content']
  end

  def mappings
    @mappings ||= Hash[MAPPINGS.map { |name| [name, VRT::Mapping.new(name)] }]
  end

  # Cache the VRT contents in-memory, so we're not hitting File I/O multiple times per
  # request that needs it.
  def reload!
    unload!
    versions
    get_json
    last_updated
    mappings
  end

  # We separate unload! out, as we need to call it in test environments.
  def unload!
    @versions = nil
    @version_json = {}
    @last_update = {}
    @mappings = nil
  end
end
