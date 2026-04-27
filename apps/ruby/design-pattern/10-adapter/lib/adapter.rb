# frozen_string_literal: true

# テキストオブジェクト（ターゲット）
class TextObject
  attr_reader :text, :size_inches, :color

  def initialize(text, size_inches, color)
    @text = text
    @size_inches = size_inches
    @color = color
  end
end

# 英国式テキストオブジェクト（Adaptee）
class BritishTextObject
  attr_reader :string, :size_mm, :colour

  def initialize(string, size_mm, colour)
    @string = string
    @size_mm = size_mm
    @colour = colour
  end
end

# クラスベース Adapter
class BritishTextObjectAdapter < TextObject
  def initialize(bto)
    @bto = bto
  end

  def text
    @bto.string
  end

  def size_inches
    @bto.size_mm / 25.4
  end

  def color
    @bto.colour
  end
end

# レンダラー（クライア���ト）
class Renderer
  def render(text_object)
    "text:#{text_object.text} size:#{text_object.size_inches} color:#{text_object.color}"
  end
end
