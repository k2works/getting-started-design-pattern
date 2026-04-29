# frozen_string_literal: true

require_relative '../../test/test_helper'
require_relative '../lib/html_report'
require_relative '../lib/plain_text_report'

class TemplateMethodTest < Minitest::Test
  def test_html_report_output
    report = TemplateMethod::HtmlReport.new

    expected = <<~HTML
      <html>
       <head>
       <title>月次報告</title>
       </head>
      <body>
       <p>順調</p>
       <p>最高の調子</p>
      </body>
      </html>
    HTML

    assert_output(expected) { report.output_report }
  end

  def test_plain_text_report_output
    report = TemplateMethod::PlainTextReport.new

    expected = <<~TEXT
      **** 月次報告 ****

      順調
      最高の調子
    TEXT

    assert_output(expected) { report.output_report }
  end

  def test_base_report_raises_on_output_line
    report = TemplateMethod::Report.new

    assert_raises(NotImplementedError) { report.output_report }
  end
end
