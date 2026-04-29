require_relative 'expression'

#
# == Allクラス
#
# Author:: k2works
# Version:: 1.0.0
# License:: Ruby License
#
class All < Expression
  def evaluate(dir)
    results = []
    Find.find(dir) do |p|
      next unless File.file?(p)
      results << p
    end
    results
  end
end
