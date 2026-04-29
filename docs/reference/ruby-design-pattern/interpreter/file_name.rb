require_relative 'expression'
#
# == ファイル名クラス
#
# Author:: k2works
# Version:: 1.0.0
# License:: Ruby License
#
class FileName < Expression
  def initialize(pattern)
    @pattern = pattern
  end

  def evaluate(dir)
    results = []
    Find.find(dir) do |p|
      next unless File.file?(p)
      name = File.basename(p)
      results << p if File.fnmatch(@pattern, name)
    end
    results
  end
end
