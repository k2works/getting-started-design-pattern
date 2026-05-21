require "singleton"
require_relative "simple_logger"

class SingletonLogger < SimpleLogger
  include Singleton
end
