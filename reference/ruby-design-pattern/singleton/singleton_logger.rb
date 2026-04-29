require './simple_logger'
require 'singleton'
class SingletonLogger < SimpleLogger
  include Singleton
end
