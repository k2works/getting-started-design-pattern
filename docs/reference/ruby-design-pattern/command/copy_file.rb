#
# == ファイルコピーコマンドクラス
#
# Author:: k2works
# Version:: 1.0.0
# License:: Ruby License
#
class CopyFile < Command
  def initialize(source, target)
    super("Copy file: #{source} to #{target}")
    @source = source
    @target = target
  end

  def execute
    FileUtils.copy(@source, @target)
  end
end
