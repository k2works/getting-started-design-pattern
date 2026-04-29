require_relative 'expression'

#
# == Biggerクラス
#
# Author:: k2works
# Version:: 1.0.0
# License:: Ruby License
#
class Bigger < Expression
  def initialize(size)
    @size = size
  end

  def evaluate(dir)
    results = []
    Find.find(dir) do |p|
      next unless File.file?(p)
      results << p if(File.size(p) > @size)
    end
    results
  end
end
