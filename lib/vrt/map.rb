module VRT
  class Map
    DEPTH_MAP = {
      'category' => 1,
      'subcategory' => 2,
      'variant' => 3
    }.freeze

    attr_reader :structure, :version

    def initialize(version = nil)
      @version = version || VRT.current_version
      @structure = build_structure
      @_found_nodes = {}
      @_lineages = {}
      @_valid_vrt_ids = {}
      @_valid_identifiers = {}
    end

    def find_node(string, max_depth: 'variant')
      @_found_nodes[string + max_depth] ||= walk_node_tree(string, max_depth: max_depth)
    end

    def valid?(vrt_id)
      @_valid_vrt_ids[vrt_id] ||= valid_identifier?(vrt_id) && !find_node(vrt_id).nil?
    end

    def get_lineage(string, max_depth: 'variant')
      @_lineages[string + max_depth] ||= construct_lineage(string, max_depth)
    end

    # Returns list of top level categories in the shape:
    # [{ value: category_id, label: category_name }]
    def categories
      structure.keys.map do |key|
        node = find_node(key.to_s, max_depth: 'category')
        { value: node.id, label: node.name }
      end
    end

    private

    def valid_identifier?(vrt_id)
      # At least one string of lowercase or _, plus up to 2 more with stops
      @_valid_identifiers[vrt_id] ||= vrt_id =~ /other|\A[a-z_\d]+(\.[a-z_\d]+){0,2}\z/
    end

    def construct_lineage(string, max_depth)
      return unless valid_identifier?(string)
      lineage = ''
      walk_node_tree(string, max_depth: max_depth) do |ids, node, level|
        return unless node
        lineage += node.name
        lineage += ' > ' unless level == ids.length
      end
      lineage
    end

    def walk_node_tree(string, max_depth: 'variant')
      id_tokens = string.split('.').map(&:to_sym)
      ids = id_tokens.take(DEPTH_MAP[max_depth])
      node = @structure[ids[0]]
      ids.each_index do |idx|
        level = idx + 1
        yield(ids, node, level) if block_given?
        node = search(ids, node, level)
      end
      node
    end

    def search(ids, node, level)
      last_level = level.eql?(ids.length)
      last_level ? node : node&.children&.dig(ids[level])
    end

    def build_structure
      VRT.get_json(version: @version).reduce({}, &method(:build_node))
    end

    def build_node(memo, vrt, parent = nil)
      node = Node.new(vrt.merge('version' => @version, 'parent' => parent))
      if node.children?
        node.children = vrt['children'].reduce({}) { |m, v| build_node(m, v, node) }
      end
      memo[node.id] = node
      memo
    end
  end
end
