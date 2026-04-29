require_relative 'expression'
#
# == 書き込み可能クラス
#
# Author:: k2works
# Version:: 1.0.0
# License:: Ruby License
#
class Writable < Expression
  def evaluate(dir)
    results = []
    Find.find(dir) do |p|
      next unless File.file?(p)
      results << p if( File.writable?(p) )
    end
    results
  end
end
