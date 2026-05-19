require_relative "test_helper"
require_relative "../lib/command"
require_relative "../lib/create_file"
require_relative "../lib/delete_file"

class CommandTest < Minitest::Test
  def test_create_and_delete_file
    path = "/tmp/command_test_#{Process.pid}.txt"
    cmd = CreateFile.new(path, "hello world\n")

    cmd.execute

    assert File.exist?(path)
    assert_equal "hello world\n", File.read(path)

    cmd.unexecute

    refute File.exist?(path)
  ensure
    File.delete(path) if File.exist?(path)
  end

  def test_delete_file_undo
    path = "/tmp/command_undo_#{Process.pid}.txt"
    File.write(path, "original content")

    cmd = DeleteFile.new(path)
    cmd.execute

    refute File.exist?(path)

    cmd.unexecute

    assert File.exist?(path)
    assert_equal "original content", File.read(path)
  ensure
    File.delete(path) if File.exist?(path)
  end
end
