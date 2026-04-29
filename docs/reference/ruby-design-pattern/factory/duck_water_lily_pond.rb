require './pond'
#
# == アヒルとスイレン＠池クラス
#
# Author:: k2works
# Version:: 1.0.0
# License:: Ruby License
#
class DuckWaterLilyPond < Pond
  def new_organism(type, name)
    if type == :animal
      Duck.new(name)
    elsif type == :plant
      WaterLily.new(name)
    else
      raise "Unknown organism type: #{type}"
    end
  end
end
