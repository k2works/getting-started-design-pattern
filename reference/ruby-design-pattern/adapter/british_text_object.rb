#
# == 英語テキストオブジェクトクラス
#
# Author:: k2works
# Version:: 1.0.0
# License:: Ruby License
#
class BritishTextObject
  attr_reader :string, :size_mm, :colour

  def initialize(string, size_mm, colour)
    @string = string
    @size_mm = size_mm
    @colour = colour
  end
end
