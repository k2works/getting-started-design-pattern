#
# == ファイル削除コマンドクラス
#
# Author:: k2works
# Version:: 1.0.0
# License:: Ruby License
#
class DeleteFile < Command
  def initialize(path)
    super("Delete file: #{path}")
    @path = path
  end

  def execute
    File.delete(@path)
  end

  def unexecute
    if @contents
      f = File.open(@path, "w")
      f.write(@contents)
      f.close
    end
  end
end