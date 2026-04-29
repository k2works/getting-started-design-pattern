#
# == レポートクラス
#
# Author:: k2works
# Version:: 1.0.0
# License:: Ruby License
#
class Report
  attr_reader :title, :text
  attr_accessor :formatter

  def initialize(&formatter)
    @title = '月次報告'
    @text = [ '順調','最高の調子' ]
    @formatter = formatter
  end

  # @return [String] レポート
  def output_report
    @formatter.call(self)
  end
end