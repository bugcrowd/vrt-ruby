require 'rails/generators/base'

module Vrt
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root(File.expand_path(File.dirname(__dir__)))
      def create_initializer_file
        copy_file '../vrt.rb', 'config/initializers/vrt.rb'
      end
    end
  end
end
