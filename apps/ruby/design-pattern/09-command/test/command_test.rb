# frozen_string_literal: true

require_relative '../../test/test_helper'
require_relative '../lib/command'

class CommandTest < Minitest::Test
  def test_create_and_delete_file
    path = "/tmp/command_test_#{Process.pid}.txt"
    cmd = CreateFile.new(path, "hello world\n")

    cmd.execute
    assert File.exist?(path)
    assert_equal "hello world\n", File.read(path)

    cmd.unexecute
    refute File.exist?(path)
  end

  def test_composite_command_description
    cmds = CompositeCommand.new
    cmds.add_command(CreateFile.new('file1.txt', "hello\n"))
    cmds.add_command(DeleteFile.new('file1.txt'))

    expected = "Create file: file1.txt\nDelete file: file1.txt\n"
    assert_equal expected, cmds.description
  end

  def test_slick_button_with_block
    output = nil
    button = SlickButton.new { output = 'pushed' }
    button.on_button_push
    assert_equal 'pushed', output
  end

  def test_delete_file_undo
    path = "/tmp/command_undo_#{Process.pid}.txt"
    File.write(path, 'original content')

    cmd = DeleteFile.new(path)
    cmd.execute
    refute File.exist?(path)

    cmd.unexecute
    assert File.exist?(path)
    assert_equal 'original content', File.read(path)
  ensure
    FileUtils.rm_f(path)
  end
end
