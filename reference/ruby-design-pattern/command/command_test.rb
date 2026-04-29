require 'minitest/autorun'
require './slick_button'
require './command'
require './composite_command'
require './create_file'
require './copy_file'
require './delete_file'

describe SlickButton do
  # 保存ボタンを押す
  it 'should putout message when it pushed.' do
    new_button = SlickButton.new do
      puts '保存しました'
    end
    proc {new_button.on_button_push}.must_output "保存しました\n"
  end
end

describe Command do
  # ファイル作成・コピー・削除コマンドを実行する
  it 'should output description of file creating,copying and delete.' do
    output =<<-EOS
Create file: file1.txt
Copy file: file1.txt to file2.txt
Delete file: file1.txt
    EOS

    cmds = CompositeCommand.new

    cmds.add_command(CreateFile.new('file1.txt', "hello world\n"))
    cmds.add_command(CopyFile.new('file1.txt', 'file2.txt'))
    cmds.add_command(DeleteFile.new('file1.txt'))

    cmds.description.must_equal output
  end
end