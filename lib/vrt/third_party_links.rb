# frozen_string_literal: true

module VRT
  class ThirdPartyLinks < Mapping
    PARENT_DIR = 'third-party-mappings'

    # Example:
    # scw = VRT::ThirdPartyLinks.new('secure-code-warrior-links', 'remediation_training')
    # scw.get(['automotive_security_misconfiguration', 'can', 'injection_dos'], '1.10.1')

    private

    def load_mappings
      @mappings = {}
      VRT.versions.each do |version|
        filename = mapping_file_path(version)
        next unless File.file?(filename)

        mapping = JSON.parse(File.read(filename))
        @mappings[version] = mapping
        # VRT.versions is sorted in reverse semver order
        # so this will end up as the earliest version with a mapping file
        @min_version = version
      end
      raise VRT::Errors::MappingNotFound if @mappings.empty?
    end

    # For flat third party links ther is no hierarchical step up
    def get_key(id_list:, mapping:, key: nil) # rubocop:disable Lint/UnusedMethodArgument
      mapping[id_list.join('.')]
    end
  end
end
