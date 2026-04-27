# frozen_string_literal: true

require "singleton"
require "stringio"

# シンプルなログクラス（テスト可能な StringIO ベース）
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

  def error(msg)
    @output.puts("[ERROR] #{msg}") if @level >= ERROR
  end

  def warning(msg)
    @output.puts("[WARNING] #{msg}") if @level >= WARNING
  end

  def info(msg)
    @output.puts("[INFO] #{msg}") if @level >= INFO
  end

  def logged_content
    @output.string
  end
end

# Singleton モジュールを使ったログクラス
class SingletonLogger < SimpleLogger
  include Singleton
end

# クラス変数ベースのログクラス
class ClassBasedLogger
  ERROR = 1
  WARNING = 2
  INFO = 3

  @@log = StringIO.new
  @@level = INFO

  def self.level=(new_level)
    @@level = new_level
  end

  def self.level
    @@level
  end

  def self.error(msg)
    @@log.puts("[ERROR] #{msg}") if @@level >= ERROR
  end

  def self.warning(msg)
    @@log.puts("[WARNING] #{msg}") if @@level >= WARNING
  end

  def self.info(msg)
    @@log.puts("[INFO] #{msg}") if @@level >= INFO
  end

  def self.logged_content
    @@log.string
  end

  def self.reset!
    @@log = StringIO.new
    @@level = INFO
  end
end

# モジュールベースのログクラス
module ModuleBasedLogger
  ERROR = 1
  WARNING = 2
  INFO = 3

  @log = StringIO.new
  @level = INFO

  def self.level=(new_level)
    @level = new_level
  end

  def self.level
    @level
  end

  def self.error(msg)
    @log.puts("[ERROR] #{msg}") if @level >= ERROR
  end

  def self.warning(msg)
    @log.puts("[WARNING] #{msg}") if @level >= WARNING
  end

  def self.info(msg)
    @log.puts("[INFO] #{msg}") if @level >= INFO
  end

  def self.logged_content
    @log.string
  end

  def self.reset!
    @log = StringIO.new
    @level = INFO
  end
end
