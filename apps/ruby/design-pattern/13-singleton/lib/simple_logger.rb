require "stringio"

class SimpleLogger
  ERROR = 1
  WARNING = 2
  INFO = 3

  attr_accessor :level
  attr_reader :output

  def initialize
    @output = StringIO.new
    @level = INFO
  end

  def error(message)
    @output.puts("[ERROR] #{message}") if @level >= ERROR
  end

  def warning(message)
    @output.puts("[WARNING] #{message}") if @level >= WARNING
  end

  def info(message)
    @output.puts("[INFO] #{message}") if @level >= INFO
  end

  def logged_content
    @output.string
  end
end
