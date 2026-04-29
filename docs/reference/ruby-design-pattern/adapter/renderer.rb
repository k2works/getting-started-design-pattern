#
# == 出力オブジェクトクラス
#
# Author:: k2works
# Version:: 1.0.0
# License:: Ruby License
#
class Renderer
  def render(text_object)
    text = text_object.text
    size = text_object.size_inches
    color = text_object.color

    # 文字列を表示します・・・
    puts "text:#{text}"
    puts "size:#{size}"
    puts "color:#{color}"
  end
end
