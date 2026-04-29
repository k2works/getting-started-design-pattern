#
# == コマンド基底クラス
#
# Author:: k2works
# Version:: 1.0.0
# License:: Ruby License
#
class Command
  attr_reader :description

  def initialize(description)
    @description = description
  end

  def execute
  end

  def unexecute
  end
end