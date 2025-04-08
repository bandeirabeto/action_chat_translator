require 'logger'

# Patch for compatibility with ActiveRecord 6.1 in Ruby 2.6
module ActiveSupport
  module LoggerThreadSafeLevel
    Logger = ::Logger
  end
end
