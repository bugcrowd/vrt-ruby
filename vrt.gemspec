lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'date'
require 'vrt/version'

Gem::Specification.new do |spec|
  spec.name          = 'vrt'
  spec.version       = Vrt::VERSION
  spec.platform      = Gem::Platform::RUBY
  spec.authors       = ['Barnett Klane', 'Max Schwenk', 'Adam David',
                        'Abhinav Nain']
  spec.email         = ['barnett@bugcrowd.com', 'max.schwenk@bugcrowd.com',
                        'adam.david@bugcrowd.com',
                        'abhinav.nain@bugcrowd.com']
  spec.date          = Date.today.to_s
  spec.summary       = "Ruby wrapper for Bugcrowd\'s Vulnerability Rating Taxonomy"
  spec.homepage      = 'https://github.com/bugcrowd/vrt-ruby'
  spec.license       = 'MIT'
  spec.files         = Dir['lib/**/*.{rb,json}']
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 3.1'

  spec.add_development_dependency 'bundler', '~> 2.5.14'
  spec.add_development_dependency 'pry', '~> 0.14.2'
  spec.add_development_dependency 'rake', '~> 13.2.1'
  spec.add_development_dependency 'rspec', '~> 3.13'
  # TODO: investigate why rubocop's jaro-winkler dependency fails to install in our alpine linux image
  spec.add_development_dependency 'rubocop', '1.52.1'
  spec.metadata = {
    'homepage_uri' => 'https://github.com/bugcrowd/vrt-ruby',
    'changelog_uri' => 'https://github.com/bugcrowd/vrt-ruby/blob/master/CHANGELOG.md',
    'source_code_uri' => 'https://github.com/bugcrowd/vrt-ruby',
    'bug_tracker_uri' => 'https://github.com/bugcrowd/vrt-ruby/issues'
  }
end
