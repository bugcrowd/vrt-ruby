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

      # iterate through the id components, keeping track of where we are in the mapping file
      # and the most specific mapped value found so far
      mapping = @mappings[version]['content']
      best_guess = @mappings[version]['metadata']['default']
      id_list.each do |id|
        entry = mapping[id]
        break unless entry # mapping file doesn't go this deep, return previous value
        best_guess = entry[@scheme] if entry[@scheme]
        # use the children mapping for the next iteration
        mapping = entry['children'] || {}
      end
      best_guess
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
      case mapping
      when Array
        mapping.each_with_object({}) { |entry, acc| acc[entry['id'].to_sym] = key_by_id(entry) }
      when Hash
        mapping.each_with_object({}) { |(key, value), acc| acc[key] = key_by_id(value) }
      else
        mapping
      end
    end
  end
end
