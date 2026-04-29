# frozen_string_literal: true

require_relative '../../test/test_helper'
require_relative '../lib/report'

class StrategyTest < Minitest::Test
  HTML_FORMATTER = lambda { |context|
    puts('<html>')
    puts('  <head>')
    puts("    <title>#{context.title}</title>")
    puts('  </head>')
    puts('  <body>')
    context.text.each do |line|
      puts("     <p>#{line}</p>")
    end
    puts('  </body>')
    puts('</html>')
  }

  def test_html_report_with_lambda
    report = Strategy::Report.new(&HTML_FORMATTER)

    expected = "<html>\n  <head>\n    <title>\u6708\u6b21\u5831\u544a</title>\n  </head>\n  <body>\n     <p>\u9806\u8abf</p>\n     <p>\u6700\u9ad8\u306e\u8abf\u5b50</p>\n  </body>\n</html>\n"

    assert_output(expected) { report.output_report }
  end

  def test_plain_text_report_with_block
    report = Strategy::Report.new do |context|
      puts("***** #{context.title} *****")
      context.text.each do |line|
        puts(line)
      end
    end

    expected = "***** \u6708\u6b21\u5831\u544a *****\n\u9806\u8abf\n\u6700\u9ad8\u306e\u8abf\u5b50\n"

    assert_output(expected) { report.output_report }
  end

  def test_formatter_can_be_swapped_at_runtime
    report = Strategy::Report.new(&HTML_FORMATTER)

    report.formatter = proc do |context|
      puts("***** #{context.title} *****")
      context.text.each { |line| puts(line) }
    end

    expected = "***** \u6708\u6b21\u5831\u544a *****\n\u9806\u8abf\n\u6700\u9ad8\u306e\u8abf\u5b50\n"

    assert_output(expected) { report.output_report }
  end
end
