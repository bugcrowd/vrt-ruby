# frozen_string_literal: true

module VRT
  class Configuration
    DEFAULT_LINEAGE_SEPARATOR = ' > '

    attr_accessor :lineage_string_separator

    private

    def initialize
      @lineage_string_separator = DEFAULT_LINEAGE_SEPARATOR
    end
  end
end

# Example usage:

# ```ruby
# def get_lineage(string, max_depth: 'variant')
#   @_lineages[string + max_depth] ||= construct_lineage(string, max_depth, VRT.configuration.lineage_string_separator)
# end
# # ...
# private
# # ...
# def construct_lineage(string, max_depth, string_separator: nil)
#   return unless valid_identifier?(string)
#   lineage = []
#   walk_node_tree(string, max_depth: max_depth) do |node|
#     return unless node
#     lineage << node.name
#   end
#   string_separator.nil? ? lineage : lineage.join(string_separator)
# end
# ```
