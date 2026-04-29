#
# == コンピュータクラス
#
# Author:: k2works
# Version:: 1.0.0
# License:: Ruby License
#
class Computer
  attr_accessor :display
  attr_accessor :motherboard
  attr_accessor :drives

  def initialize(display=:crt, motherboard=Motherboard.new, drives=[])
    @motherboard = motherboard
    @drives = drives
    @display = display
  end
end
