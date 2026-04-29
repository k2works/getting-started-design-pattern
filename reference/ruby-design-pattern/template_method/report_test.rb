require './report'
require './html_report'
require './plaine_text_report'
require 'minitest/autorun'

describe Report do
  # HTMLレポートが出力される
  it 'should output HTML report.' do
    @my = HTMLReport.new

    report = <<-EOS
<html>
 <head>
 <title>月次報告</title>
 </head>
<body>
 <p>順調</p>
 <p>最高の調子</p>
</body>
</html>
    EOS
    proc {@my.output_report}.must_output report
  end

  # プレーンテキストのレポートが出力される
  it 'should output plain text report.' do
    @my = PlaineTextReport.new

    report = <<-EOS
**** 月次報告 ****

順調
最高の調子
    EOS
    proc {@my.output_report}.must_output report
  end
end