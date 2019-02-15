module VRT
  module CrossVersionMapping
    # Maps new_category_id: deprecated_node_id
    # and new_subcategory_id: deprecated_node_id
    def cross_version_category_mapping
      category_map = {}
      deprecated_node_json.each do |key, value|
        latest_version = value.keys.max_by { |n| Gem::Version.new(n) }
        id_list = value[latest_version].split('.')
        cat_id = id_list[0]
        sub_id = id_list[0..1].join('.')
        category_map[cat_id] ? category_map[cat_id] << key : category_map[cat_id] = [key]
        category_map[sub_id] ? category_map[sub_id] << key : category_map[sub_id] = [key]
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
      deprecated_node_json[vrt_id].keys.max_by { |n| Gem::Version.new(n) }
    end

    def find_deprecated_node(vrt_id, new_version = nil, max_depth = 'variant')
      version = latest_version_for_deprecated_node(vrt_id)
      node_id = deprecated_node_json[vrt_id][new_version] || deprecated_node_json[vrt_id][version]
      new_node = VRT::Map.new(new_version).find_node(node_id, max_depth: max_depth)
      new_node.nil? ? find_deprecated_node(node_id, new_version, max_depth) : new_node
    end

    def find_valid_parent_node(vrt_id, new_version, max_depth)
      new_map = VRT::Map.new(new_version)
      if new_map.valid?(vrt_id)
        new_map.find_node(vrt_id, max_depth: max_depth)
      else
        parent = vrt_id.split('.')[0..-2].join('.')
        return nil if parent.empty?

        find_valid_parent_node(parent, new_version, max_depth)
      end
    end
  end
end
