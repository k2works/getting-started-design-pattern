# frozen_string_literal: true

require_relative "../../test/test_helper"
require_relative "../lib/singleton_pattern"

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

  def test_warning_logs_error_and_warning
    @logger.level = SimpleLogger::WARNING
    @logger.error("disk full")
    @logger.warning("low space")
    @logger.info("should not appear")

    assert_includes @logger.logged_content, "[ERROR] disk full"
    assert_includes @logger.logged_content, "[WARNING] low space"
    refute_includes @logger.logged_content, "[INFO]"
  end

  def test_info_logs_all_levels
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

  def test_logs_messages
    logger = SingletonLogger.instance
    logger.info("singleton test")

    assert_includes logger.logged_content, "[INFO] singleton test"
  end
end

class ClassBasedLoggerTest < Minitest::Test
  def setup
    ClassBasedLogger.reset!
  end

  def test_class_level_logging
    ClassBasedLogger.info("class info")
    ClassBasedLogger.warning("class warning")
    ClassBasedLogger.error("class error")

    content = ClassBasedLogger.logged_content
    assert_includes content, "[INFO] class info"
    assert_includes content, "[WARNING] class warning"
    assert_includes content, "[ERROR] class error"
  end

  def test_respects_level_setting
    ClassBasedLogger.level = ClassBasedLogger::ERROR
    ClassBasedLogger.info("should not appear")
    ClassBasedLogger.error("should appear")

    content = ClassBasedLogger.logged_content
    refute_includes content, "[INFO]"
    assert_includes content, "[ERROR] should appear"
  end
end

class ModuleBasedLoggerTest < Minitest::Test
  def setup
    ModuleBasedLogger.reset!
  end

  def test_module_level_logging
    ModuleBasedLogger.info("module info")
    ModuleBasedLogger.warning("module warning")
    ModuleBasedLogger.error("module error")

    content = ModuleBasedLogger.logged_content
    assert_includes content, "[INFO] module info"
    assert_includes content, "[WARNING] module warning"
    assert_includes content, "[ERROR] module error"
  end

  def test_respects_level_setting
    ModuleBasedLogger.level = ModuleBasedLogger::ERROR
    ModuleBasedLogger.info("should not appear")
    ModuleBasedLogger.error("should appear")

    content = ModuleBasedLogger.logged_content
    refute_includes content, "[INFO]"
    assert_includes content, "[ERROR] should appear"
  end
end
