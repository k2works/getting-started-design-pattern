require './pond'
#
# == アヒル＠池クラス
#
# Author:: k2works
# Version:: 1.0.0
# License:: Ruby License
#
class DuckPond < Pond
  def new_organism(type, name)
    if type == :animal
      Duck.new(name)
    else
      raise "Unknown organism type: #{type}"
    end
  end
end
