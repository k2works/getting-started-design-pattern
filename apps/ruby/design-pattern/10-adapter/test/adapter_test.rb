require_relative "test_helper"
require_relative "../lib/text_object"
require_relative "../lib/british_text_object"
require_relative "../lib/british_text_object_adapter"
require_relative "../lib/renderer"

class AdapterTest < Minitest::Test
  def test_render_text_object
    renderer = Renderer.new
    text = TextObject.new("Hello", 1.0, :blue)

    result = renderer.render(text)

    assert_equal "text:Hello size:1.0 color:blue", result
  end

  def test_render_british_text_object_via_adapter
    renderer = Renderer.new
    british_text_object = BritishTextObject.new("Hello", 25.4, :blue)
    adapted = BritishTextObjectAdapter.new(british_text_object)

    result = renderer.render(adapted)

    assert_equal "text:Hello size:1.0 color:blue", result
  end
end
