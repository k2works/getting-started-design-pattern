# frozen_string_literal: true

require_relative "../../test/test_helper"
require_relative "../lib/adapter"

class AdapterTest < Minitest::Test
  def test_render_text_object
    renderer = Renderer.new
    text = TextObject.new("Hello", 1.0, :blue)
    result = renderer.render(text)
    assert_equal "text:Hello size:1.0 color:blue", result
  end

  def test_render_british_text_object_via_adapter
    renderer = Renderer.new
    bto = BritishTextObject.new("Hello", 25.4, :blue)
    adapted = BritishTextObjectAdapter.new(bto)
    result = renderer.render(adapted)
    assert_equal "text:Hello size:1.0 color:blue", result
  end

  def test_singleton_method_adapter
    bto = BritishTextObject.new("Hello", 50.8, :red)

    def bto.text = string
    def bto.size_inches = size_mm / 25.4
    def bto.color = colour

    renderer = Renderer.new
    result = renderer.render(bto)
    assert_equal "text:Hello size:2.0 color:red", result
  end
end
