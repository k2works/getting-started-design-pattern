require 'minitest/autorun'
require './report'

describe Report do
  # HTMLレポートが出力される
  it 'should output HTML report.' do

    HTML_FORMATTER = lambda do |context|
      puts('<html>')
      puts('  <head>')
      puts("    <title>#{context.title}</title>")
      puts('  </head>')
      puts('  <body>')
      context.text.each do |line|
        puts("     <p>#{line}</p>" )
      end
      puts('  </body>')
      puts('</html>')
    end

    @my = Report.new &HTML_FORMATTER

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
    @my = Report.new do |context|
      puts("***** #{context.title} *****")
      context.text.each do |line|
        puts(line)
      end
    end

    report = <<-EOS
***** 月次報告 *****
順調
最高の調子
    EOS
    proc {@my.output_report}.must_output report
  end
end