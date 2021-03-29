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
