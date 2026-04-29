#
# == 木クラス
#
# Author:: k2works
# Version:: 1.0.0
# License:: Ruby License
#
class Tree
  def initialize(name)
    @name = name
  end

  def grow
    puts("樹木#{@name}が高く育っています。")
  end
end
