require_relative "text_object"
require_relative "british_text_object"

class BritishTextObjectAdapter < TextObject
  def initialize(british_text_object)
    @british_text_object = british_text_object
  end

  def text
    @british_text_object.string
  end

  def size_inches
    @british_text_object.size_mm / 25.4
  end

  def color
    @british_text_object.colour
  end
end
