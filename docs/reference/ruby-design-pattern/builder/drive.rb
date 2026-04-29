#
# == ドライブクラス
#
# Author:: k2works
# Version:: 1.0.0
# License:: Ruby License
#
class Drive
  attr_accessor :type # :hard_diskか:cdか:dvd
  attr_accessor :size # MBで
  attr_accessor :writable # ドライブが書き込み可能ならばtrue

  def initialize(type, size, writable)
    @type = type
    @size = size
    @writable = writable
  end
end