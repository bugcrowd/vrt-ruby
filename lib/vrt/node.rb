module VRT
  class Node
    attr_reader :id, :name, :priority, :type, :version, :parent, :qualified_vrt_id
    attr_accessor :children

    def initialize(attributes = {})
      @id = attributes['id'].to_sym
      @name = attributes['name']
      @priority = attributes['priority']
      @type = attributes['type']
      @has_children = attributes.key?('children')
      @children = {}
      @version = attributes['version']
      @parent = attributes['parent']
      @qualified_vrt_id = construct_vrt_id
    end

    def children?
      @has_children
    end

    def construct_vrt_id
      id_list.join('.')
    end

    def mappings
      Hash[VRT.mappings.map { |name, map| [name, map.get(id_list, @version)] }]
    end

    def third_party_links
      Hash[VRT.third_party_links.map { |name, map| [name, map.get(id_list, @version)] }]
    end

    def id_list
      parent ? parent.id_list << id : [id]
    end

    # Since this object contains references to parent and children,
    # as_json must be overridden to avoid unending recursion.
    def as_json(options = nil)
      json = {}
      instance_variables.each do |attribute|
        attr_name = attribute.to_s.tr('@', '')
        json[attr_name] = case attr_name
                          when 'parent'
                            parent&.qualified_vrt_id
                          when 'children'
                            children.inject({}) do |c, (k, v)|
                              c[k] = v.nil? ? v : v.as_json(options)
                            end
                          else
                            instance_variable_get(attribute)
                          end
      end
      json
    end
  end
end
