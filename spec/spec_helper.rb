require 'simplecov'
SimpleCov.start

require 'bundler/setup'
require 'vrt'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:each) do
    # The following adds a new, test-only VRT version ('999.999')
    VRT.unload!
    stub_const('VRT::DIR', Pathname.new('spec/sample_vrt'))
  end
end
