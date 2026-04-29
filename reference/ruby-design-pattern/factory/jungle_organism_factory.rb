#
# == ジャングル有機体ファクトリークラス
#
# Author:: k2works
# Version:: 1.0.0
# License:: Ruby License
#
class JungleOrganismFactory
  def new_animal(name)
    Tiger.new(name)
  end

  def new_plant(name)
    Tree.new(name)
  end
end