#
# == 文字列インプットアダプタークラス
#
# Author:: k2works
# Version:: 1.0.0
# License:: Ruby License
#
class StringIOAdapter
  def initialize(string)
    @string = string
    @position = 0
  end

  def getbyte
    raise EOFError if @position >= @string.length

    ch = @string.getbyte(@position)
    @position += 1
    ch
  end

  def eof?
    return @position >= @string.length
  end
end
