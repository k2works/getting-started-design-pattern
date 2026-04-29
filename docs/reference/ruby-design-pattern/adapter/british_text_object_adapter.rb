#
# == 英語テキストアダプタークラス
#
# Author:: k2works
# Version:: 1.0.0
# License:: Ruby License
#
class BritishTextObjectAdapter < TextObject
  def initialize(bto)
    @bto = bto
  end

  def text
    return @bto.string
  end

  def size_inches
    return @bto.size_mm / 25.4
  end

  def color
    return @bto.colour
  end
end
