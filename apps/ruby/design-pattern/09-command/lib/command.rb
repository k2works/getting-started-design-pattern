# frozen_string_literal: true

# コマンド基底クラス（Command パターン）
class Command
  attr_reader :description

  def initialize(description)
    @description = description
  end

  def execute; end
  def unexecute; end
end

# 複合コマンド
class CompositeCommand < Command
  def initialize
    @commands = []
  end

  def add_command(cmd)
    @commands << cmd
  end

  def execute
    @commands.each(&:execute)
  end

  def unexecute
    @commands.reverse_each(&:unexecute)
  end

  def description
    "#{@commands.map(&:description).join("\n")}\n"
  end
end

# ファイル作成コマンド
class CreateFile < Command
  def initialize(path, contents)
    super("Create file: #{path}")
    @path = path
    @contents = contents
  end

  def execute
    File.write(@path, @contents)
  end

  def unexecute
    FileUtils.rm_f(@path)
  end
end

# ファイル削除コマンド
class DeleteFile < Command
  def initialize(path)
    super("Delete file: #{path}")
    @path = path
  end

  def execute
    @contents = File.read(@path) if File.exist?(@path)
    FileUtils.rm_f(@path)
  end

  def unexecute
    File.write(@path, @contents) if @contents
  end
end

# ブロックベースのボタン（Ruby らしい Command）
class SlickButton
  attr_accessor :command

  def initialize(&block)
    @command = block
  end

  def on_button_push
    @command&.call
  end
end
