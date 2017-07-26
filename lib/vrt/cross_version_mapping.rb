module VRT
  module CrossVersionMapping
    # Maps new_category_id: deprecated_node_id
    def cross_version_category_mapping
      category_map = {}
      deprecated_node_json.each do |key, value|
        latest_version = value.keys.sort_by { |n| Gem::Version.new(n) }.last
        id = value[latest_version].split('.')[0]
        category_map[id] ? category_map[id] << key : category_map[id] = [key]
      end
      category_map
    end

    # Map shape: { deprecated_id: { version: new_mapped_id } }
    def deprecated_node_json
      filename = VRT::DIR.join(current_version, 'deprecated-node-mapping.json')
      File.file?(filename) ? JSON.parse(File.read(filename)) : {}
    end

    def deprecated_node?(vrt_id)
      deprecated_node_json[vrt_id]
    end

    def latest_version_for_deprecated_node(vrt_id)
      deprecated_node_json[vrt_id].keys.sort_by { |n| Gem::Version.new(n) }.last
    end

    def find_deprecated_node(vrt_id, new_version = nil, max_depth = 'variant')
      version = latest_version_for_deprecated_node(vrt_id)
      node_id = deprecated_node_json[vrt_id][new_version] || deprecated_node_json[vrt_id][version]
      VRT::Map.new(new_version).find_node(node_id, max_depth: max_depth)
    end

    def find_valid_parent_node(vrt_id, old_version, new_version, max_depth)
      old_node = VRT::Map.new(old_version).find_node(vrt_id)
      new_map = VRT::Map.new(new_version)
      if new_map.valid?(vrt_id)
        new_map.find_node(vrt_id, max_depth: max_depth)
      else
        return nil if old_node.parent.nil?
        find_valid_parent_node(old_node.parent.qualified_vrt_id, old_version, new_version, max_depth)
      end
    end
  end
end
