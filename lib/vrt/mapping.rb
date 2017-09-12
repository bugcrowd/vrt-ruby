module VRT
  class Mapping
    def initialize(scheme)
      @scheme = scheme
      @mapping = load_mapping
    end

    # returns the most specific value provided in the mapping file
    def get(id_list)
      mapping = @mapping['content']
      best_guess = nil
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

    def load_mapping
      filename = VRT::DIR.join(VRT.current_version, 'mappings', "#{@scheme}.json")
      mapping = File.file?(filename) ? JSON.parse(File.read(filename)) : {}
      mapping['content'] = key_by_id(mapping['content'])
      mapping
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

    class CVSSv3 < Mapping
      def initialize
        super('cvss_v3')
      end
    end
  end
end
