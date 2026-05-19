require_relative "test_helper"
require_relative "../lib/simple_writer"
require_relative "../lib/writer_decorator"
require_relative "../lib/numbering_writer"
require_relative "../lib/time_stamping_writer"

class DecoratorTest < Minitest::Test
  def setup
    @path = "/tmp/decorator_test_#{Process.pid}.txt"
  end

  def teardown
    File.delete(@path) if File.exist?(@path)
  end

  def test_simple_writer
    writer = SimpleWriter.new(@path)
    writer.write_line("Hello")
    writer.close

    assert_equal "Hello\n", File.read(@path)
  end

  def test_numbering_writer
    writer = NumberingWriter.new(SimpleWriter.new(@path))
    writer.write_line("Hello")
    writer.write_line("World")
    writer.close

    assert_equal "1: Hello\n2: World\n", File.read(@path)
  end

  def test_stacked_decorators
    writer = TimeStampingWriter.new(
      NumberingWriter.new(
        SimpleWriter.new(@path)
      )
    )
    writer.write_line("Hello")
    writer.close

    content = File.read(@path)
    assert_match(/1: \d{4}-\d{2}-\d{2}.*: Hello/, content)
  end
end
