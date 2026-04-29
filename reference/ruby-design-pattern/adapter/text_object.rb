#
# == テキストオブジェクトクラス
#
# Author:: k2works
# Version:: 1.0.0
# License:: Ruby License
#
class TextObject
  attr_reader :text, :size_inches, :color

  def initialize(text, size_inches, color)
    @text = text
    @size_inches = size_inches
    @color = color
  end
end
