#
# == ボタンオブジェクトクラス
#
# Author:: k2works
# Version:: 1.0.0
# License:: Ruby License
#
class SlickButton
  attr_accessor :command

  def initialize(&block)
    @command = block
  end

  def on_button_push
    @command.call if @command
  end
end
