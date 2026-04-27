# frozen_string_literal: true

require_relative "report"

module TemplateMethod
  # プレーンテキスト形式のレポート出力
  class PlainTextReport < Report
    def output_head
      puts("**** #{@title} ****")
      puts
    end

    def output_line(line)
      puts(line)
    end
  end
end
