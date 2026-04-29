#
# == 藻クラス
#
# Author:: k2works
# Version:: 1.0.0
# License:: Ruby License
#
class Algae
  def initialize(name)
    @name = name
  end

  def grow
    puts("藻#{@name}は日光を浴びて育ちます。")
  end
end