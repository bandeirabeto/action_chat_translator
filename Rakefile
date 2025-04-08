require_relative './bootstrap'
require 'active_record'
require 'yaml'
require 'rake'
require 'dotenv/load'

namespace :db do
  task :load_config do
    config = YAML.load_file('config/database.yml')
    ActiveRecord::Base.establish_connection(config[ENV['RACK_ENV'] || 'development'])
  end

  desc "Create the database"
  task create: :load_config do
    ActiveRecord::Base.connection
  rescue ActiveRecord::NoDatabaseError
    `createdb #{ActiveRecord::Base.connection_config[:database]}`
    retry
  end

  desc "Run migrations"
  task migrate: :load_config do
    ActiveRecord::Migration.verbose = true
    migration_path = File.expand_path('db/migrations', __dir__)
    ActiveRecord::MigrationContext.new(migration_path, ActiveRecord::SchemaMigration).migrate
  end
end
