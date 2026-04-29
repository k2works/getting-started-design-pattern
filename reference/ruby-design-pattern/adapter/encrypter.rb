#
# == コマンド基底クラス
#
# Author:: k2works
# Version:: 1.0.0
# License:: Ruby License
#
class Encrypter
  def initialize(key)
    @key = key
  end

  def encrypt(reader, writer)
    key_index = 0
    while not reader.eof?
      encrypted_char = reader.getbyte ^ @key.getbyte(key_index)
      writer.putc(encrypted_char)
      key_index = (key_index + 1) % @key.size
    end
  end
end