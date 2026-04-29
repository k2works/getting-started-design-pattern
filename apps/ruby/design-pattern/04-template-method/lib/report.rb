# frozen_string_literal: true

module TemplateMethod
  # 基底レポートクラス（Template Method パターン）
  #
  # テンプレートメソッド output_report が処理の骨格を定義し、
  # サブクラスが各ステップ（フックメソッド）をオーバーライドする。
  class Report
    def initialize
      @title = '月次報告'
      @text = %w[順調 最高の調子]
    end

    # テンプレートメソッド: レポート出力の骨格
    def output_report
      output_start
      output_head
      output_body_start
      output_body
      output_body_end
      output_end
    end

    def output_body
      @text.each do |line|
        output_line(line)
      end
    end

    # フックメソッド（デフォルトは何もしない）
    def output_start; end

    def output_head
      output_line(@title)
    end

    def output_body_start; end

    # 抽象メソッド: サブクラスでオーバーライド必須
    def output_line(_line)
      raise NotImplementedError, 'サブクラスで output_line を実装してください'
    end

    def output_body_end; end
    def output_end; end
  end
end
