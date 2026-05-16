require_relative "test_helper"
require_relative "../lib/report"

class StrategyTest < Minitest::Test
  HTML_FORMATTER = lambda { |context|
    puts("<html>")
    puts("  <head>")
    puts("    <title>#{context.title}</title>")
    puts("  </head>")
    puts("  <body>")
    context.text.each { |line| puts("     <p>#{line}</p>") }
    puts("  </body>")
    puts("</html>")
  }

  def test_html_report_with_lambda
    report = Strategy::Report.new(&HTML_FORMATTER)

    assert_output(/html/) { report.output_report }
  end

  def test_plain_text_report_with_block
    report = Strategy::Report.new do |context|
      puts("***** #{context.title} *****")
      context.text.each { |line| puts(line) }
    end

    assert_output(/月次報告/) { report.output_report }
  end

  def test_formatter_can_be_swapped_at_runtime
    report = Strategy::Report.new(&HTML_FORMATTER)
    report.formatter = proc { |context| puts(context.title) }

    assert_output(/月次報告/) { report.output_report }
  end
end
