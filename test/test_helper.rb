$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "mongoid"
require "mongoid/enum_attribute"

require "bundler/setup"
require "database_cleaner/mongoid"
require "minitest"
require "minitest/autorun"
require "minitest/spec"

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

Mongoid.configure do |config|
  config.connect_to('mongoid-enum_attribute_test')
end

Mongoid.logger.level = Logger::INFO
Mongo::Logger.logger.level = Logger::INFO

class Minitest::Spec
  before(:each) { DatabaseCleaner.start }
  after(:each) { DatabaseCleaner.clean }
end
