#
# == 有機体＠池ファクトリークラス
#
# Author:: k2works
# Version:: 1.0.0
# License:: Ruby License
#
class PondOrganismFactory
  def new_animal(name)
    Duck.new(name)
  end

  def new_plant(name)
    WaterLily.new(name)
  end
end
