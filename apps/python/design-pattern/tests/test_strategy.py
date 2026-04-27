"""Strategy パターンのテスト"""

from src.strategy import Report, html_formatter, plain_text_formatter


class TestHtmlFormatter:
    def test_html形式でレポートを出力する(self):
        report = Report(html_formatter)
        result = report.output_report()
        assert "<html>" in result
        assert "</html>" in result

    def test_htmlにタイトルを含む(self):
        report = Report(html_formatter)
        result = report.output_report()
        assert "<title>月次報告</title>" in result

    def test_htmlにテキスト行を含む(self):
        report = Report(html_formatter)
        result = report.output_report()
        assert "<p>順調</p>" in result
        assert "<p>最高の調子</p>" in result


class TestPlainTextFormatter:
    def test_プレーンテキスト形式でレポートを出力する(self):
        report = Report(plain_text_formatter)
        result = report.output_report()
        assert "***** 月次報告 *****" in result

    def test_プレーンテキストにテキスト行を含む(self):
        report = Report(plain_text_formatter)
        result = report.output_report()
        assert "順調" in result
        assert "最高の調子" in result


class TestStrategySwap:
    def test_実行時にフォーマッタを切り替えられる(self):
        report = Report(html_formatter)
        assert "<html>" in report.output_report()

        report.formatter = plain_text_formatter
        assert "***** 月次報告 *****" in report.output_report()

    def test_ラムダをフォーマッタとして使える(self):
        custom = lambda r: f"CUSTOM: {r.title}"
        report = Report(custom)
        assert report.output_report() == "CUSTOM: 月次報告"
