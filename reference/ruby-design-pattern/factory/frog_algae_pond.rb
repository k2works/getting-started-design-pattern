require './pond'
#
# == カエルと藻＠池クラス
#
# Author:: k2works
# Version:: 1.0.0
# License:: Ruby License
#
class FrogAlgaePond < Pond
  def new_organism(type, name)
    if type == :animal
      Frog.new(name)
    elsif type == :plant
      Algae.new(name)
    else
      raise "Unknown organism type: #{type}"
    end
  end
end