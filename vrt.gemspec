lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'date'
require 'vrt/version'

Gem::Specification.new do |spec|
  spec.name          = 'vrt'
  spec.version       = Vrt::VERSION
  spec.platform      = Gem::Platform::RUBY
  spec.authors       = ['Barnett Klane', 'Max Schwenk', 'Adam David']
  spec.email         = ['barnett@bugcrowd.com', 'max.schwenk@bugcrowd.com', 'adam.david@bugcrowd.com']
  spec.date          = Date.today.to_s
  spec.summary       = "Ruby wrapper for Bugcrowd\'s Vulnerability Rating Taxonomy"
  spec.homepage      = 'https://github.com/bugcrowd/vrt-ruby'
  spec.license       = 'MIT'
  spec.files         = Dir['lib/**/*.{rb,json}']
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.5'

  spec.add_development_dependency 'bundler', '~> 2.1'
  spec.add_development_dependency 'pry', '~> 0.12'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.9'
  spec.add_development_dependency 'rubocop', '~> 0.78'
end
