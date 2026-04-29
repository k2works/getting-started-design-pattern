require 'minitest/autorun'
require './encrypter'
require './string_io_adapter'
require './renderer'
require './text_object'
require './british_text_object'
require './british_text_object_adapter'

describe Encrypter do
  before(:each) do
    @encrypter = Encrypter.new('my seret key')
  end

  # 入力ファイルが暗号化される
  it 'should encrypt input file.' do
    reader = File.open('message.txt')
    writer = File.open('message.encrypted','w')
    @encrypter.encrypt(reader,writer)
    reader.wont_equal writer
  end
end

describe StringIOAdapter do
  before(:each) do
    @string_io_adapter = StringIOAdapter.new('We attack at dawn')
  end

  # ファイルではなく文字列を暗号化する
  it 'should not encrypt fle but string array.' do
    encrypter = Encrypter.new('XYZZY')
    reader = @string_io_adapter
    writer = File.open('out.txt','w')
    encrypter.encrypt(reader,writer)
    reader.wont_equal writer
  end
end

describe Renderer do
  before(:each) do
    @render = Renderer.new
  end

  # TextObjectの内容が出力される
  it 'should output contents of TextObject.' do
    output =<<EOS
text:Hoge
size:25.4
color:blue
EOS
    text_object = TextObject.new('Hoge',25.4,:blue)
    proc{@render.render(text_object)}.must_output output
  end

  # BritishTextObjectの内容が出力される
  it 'should output contents of BritishTextObject.' do
    output =<<EOS
text:hello
size:1.0
color:blue
EOS
    text_object = BritishTextObjectAdapter.new(BritishTextObject.new('hello',25.4,:blue))
    proc{@render.render(text_object)}.must_output output
  end

  # BritishTextObjectの内容が出力される
  it 'should output contents of BritishTextObject.' do
    output =<<EOS
text:hello
size:1.0
color:blue
EOS

    class BritishTextObject
      def color
        return colour
      end

      def text
        return string
      end

      def size_inches
        return size_mm / 25.4
      end
    end

    text_object = BritishTextObject.new('hello',25.4,:blue)
    proc{@render.render(text_object)}.must_output output
  end

  # BritishTextObjectの内容が出力される
  it 'should output contents of BritishTextObject.' do
    output =<<EOS
text:hello
size:2.0
color:blue
EOS

    bto = BritishTextObject.new('hello',50.8, :blue)

    class << bto
      def color
        colour
      end

      def text
        string
      end

      def size_inches
        return size_mm / 25.4
      end
    end

    proc{@render.render(bto)}.must_output output
  end
end