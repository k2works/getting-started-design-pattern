require './pond'
#
# == カエル＠池クラス
#
# Author:: k2works
# Version:: 1.0.0
# License:: Ruby License
#
class FrogPond < Pond
  def new_organism(type, name)
    if type == :animal
      Frog.new(name)
    else
      raise "Unknown organism type: #{type}"
    end
  end
end