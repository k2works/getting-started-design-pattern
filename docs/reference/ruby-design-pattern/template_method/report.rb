#
# == 基底レポートクラス
#
# Author:: k2works
# Version:: 1.0.0
# License:: Ruby License
#
class Report
  def initialize
    @title = '月次報告'
    @text = ['順調', '最高の調子']
  end

  # @return [String] レポート
  def output_report
    output_start
    output_head
    output_body_start
    output_body
    output_body_end
    output_end
  end

  # @return [String] テキスト内容
  def output_body
    @text.each do |line|
      output_line(line)
    end
  end

  def output_start
  end

  # @return [String] タイトル
  def output_head
    output_line(@title)
  end

  def output_body_start
  end

  #️ @abstract 抽象メソッドなのでoverrideしてください
  def output_line(line)
    raise 'Called abstract method: output_line'
  end

  def output_body_end
  end

  def output_end
  end
end