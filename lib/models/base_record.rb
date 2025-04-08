require 'active_record'
require 'yaml'

class BaseRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.setup_connection!
    config_path = File.expand_path('../../../config/database.yml', __FILE__)
    db_config = YAML.load_file(config_path)
    environment = ENV['RACK_ENV'] || 'development'

    establish_connection(db_config[environment])
  end
end
