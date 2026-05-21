require "stringio"
require_relative "test_helper"
require_relative "../lib/simple_logger"
require_relative "../lib/singleton_logger"

class SimpleLoggerTest < Minitest::Test
  def setup
    @logger = SimpleLogger.new
  end

  def test_default_level_is_info
    assert_equal SimpleLogger::INFO, @logger.level
  end

  def test_error_logs_at_error_level
    @logger.level = SimpleLogger::ERROR
    @logger.error("disk full")
    @logger.warning("should not appear")
    @logger.info("should not appear")

    assert_includes @logger.logged_content, "[ERROR] disk full"
    refute_includes @logger.logged_content, "[WARNING]"
    refute_includes @logger.logged_content, "[INFO]"
  end

  def test_info_logs_all_levels
    @logger.level = SimpleLogger::INFO
    @logger.error("disk full")
    @logger.warning("low space")
    @logger.info("all is well")

    assert_includes @logger.logged_content, "[ERROR] disk full"
    assert_includes @logger.logged_content, "[WARNING] low space"
    assert_includes @logger.logged_content, "[INFO] all is well"
  end
end

class SingletonLoggerTest < Minitest::Test
  def test_returns_same_instance
    logger1 = SingletonLogger.instance
    logger2 = SingletonLogger.instance

    assert_same logger1, logger2
  end

  def test_cannot_create_with_new
    assert_raises(NoMethodError) { SingletonLogger.new }
  end
end
