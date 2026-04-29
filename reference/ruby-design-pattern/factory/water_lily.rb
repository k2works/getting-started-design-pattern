#
# == スイレンクラス
#
# Author:: k2works
# Version:: 1.0.0
# License:: Ruby License
#
class WaterLily
  def initialize(name)
    @name = name
  end

  def grow
    puts("スイレン#{@name}は浮きながら日光を浴びて育ちます。")
  end
end