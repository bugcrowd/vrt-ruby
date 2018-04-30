module VRT
  class Mapping
    def initialize(scheme)
      @scheme = scheme.to_s
      load_mappings
    end

    # returns the most specific value provided in the mapping file for the given vrt id
    #
    # if no mapping file exists for the given version, the mapping file for the earliest version available will be used
    def get(id_list, version)
      # update the vrt id to the first version we have a mapping file for
      unless @mappings.key?(version)
        id_list = VRT.find_node(vrt_id: id_list.join('.'), preferred_version: @min_version).id_list
        version = @min_version
      end
      mapping = @mappings[version]['content']
      default = @mappings[version]['metadata']['default']
      keys = @mappings[version]['metadata']['keys']
      if keys
        # Convert mappings with multiple keys to be nested under a single
        # top-level key. Remediation advice has keys 'remediation_advice'
        # and 'references' so we convert it to look like
        # { remediation_advice: { remediation_advice: '...', references: [...] } }
        keys.each_with_object({}) do |key, acc|
          acc[key.to_sym] = get_key(
            id_list: id_list,
            mapping: mapping,
            key: key,
            default: default&.try(:[], key)
          )
        end
      else
        get_key(id_list: id_list, mapping: mapping, key: @scheme, default: default)
      end
    end

    private

    def load_mappings
      @mappings = {}
      VRT.versions.each do |version|
        filename = VRT::DIR.join(version, 'mappings', "#{@scheme}.json")
        next unless File.file?(filename)
        mapping = JSON.parse(File.read(filename))
        mapping['content'] = key_by_id(mapping['content'])
        @mappings[version] = mapping
        # VRT.versions is sorted in reverse semver order
        # so this will end up as the earliest version with a mapping file
        @min_version = version
      end
    end

    # Converts arrays to hashes keyed by the id attribute (as a symbol) for easier lookup. So
    #     [{'id': 'one', 'foo': 'bar'}, {'id': 'two', 'foo': 'baz'}]
    # becomes
    #     {one: {'id': 'one', 'foo': 'bar'}, two: {'id': 'two', 'foo': 'baz'}}
    def key_by_id(mapping)
      if mapping.is_a?(Array) && mapping.first.is_a?(Hash) && mapping.first.key?('id')
        mapping.each_with_object({}) { |entry, acc| acc[entry['id'].to_sym] = key_by_id(entry) }
      elsif mapping.is_a?(Hash)
        mapping.each_with_object({}) { |(key, value), acc| acc[key] = key_by_id(value) }
      else
        mapping
      end
    end

    def get_key(id_list:, mapping:, key:, default:)
      # iterate through the id components, keeping track of where we are in the mapping file
      # and the most specific mapped value found so far
      best_guess = default
      id_list.each do |id|
        entry = mapping[id]
        break unless entry # mapping file doesn't go this deep, return previous value
        best_guess = merge_arrays(best_guess, entry[key]) if entry[key]
        # use the children mapping for the next iteration
        mapping = entry['children'] || {}
      end
      best_guess
    end

    def merge_arrays(previous_value, new_value)
      if previous_value.is_a?(Array) && new_value.is_a?(Array)
        new_value | previous_value
      else
        new_value
      end
    end
  end
end
