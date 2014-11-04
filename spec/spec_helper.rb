RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.deprecation_stream = '/dev/null'
  config.order = 'random'
  # config.mock_with :mocha
  config.mock_with :rspec
end

# require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet'
