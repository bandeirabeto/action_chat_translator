require_relative '../bootstrap'
require_relative '../lib/web/server'
require_relative '../lib/models/base_record'
require 'dotenv/load'

BaseRecord.setup_connection!
Web::Server.start
