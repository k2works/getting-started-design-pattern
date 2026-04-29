#
# == ラップトップPCビルダークラス
#
# Author:: k2works
# Version:: 1.0.0
# License:: Ruby License
#
class LaptopComputer < Computer
  def initialize( motherboard=Motherboard.new, drives=[])
    super(:lcd, motherboard, drives)
  end

  # ラップトップの詳細に関するたくさんのコード

end