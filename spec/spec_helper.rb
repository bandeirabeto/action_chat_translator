require_relative '../bootstrap'
require_relative '../lib/models/base_record'
require 'dotenv/load'
require 'rspec'

ENV["RACK_ENV"] ||= "test"

BaseRecord.setup_connection!

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
    mocks.verify_partial_doubles = true
  end

  config.before(:each) do
    Message.delete_all
    Conversation.delete_all
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end

Dir[File.expand_path('../../lib/**/*.rb', __FILE__)].each { |file| require file }
