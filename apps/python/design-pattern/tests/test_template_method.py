"""Template Method パターンのテスト"""

import pytest
from src.template_method import HtmlReport, PlainTextReport, Report


class TestHtmlReport:
    def test_html形式でレポートを出力する(self):
        report = HtmlReport()
        result = report.output_report()
        assert "<html>" in result
        assert "</html>" in result

    def test_htmlヘッダーにタイトルを含む(self):
        report = HtmlReport()
        result = report.output_report()
        assert "<title>月次報告</title>" in result

    def test_html本文にテキストをp要素で含む(self):
        report = HtmlReport()
        result = report.output_report()
        assert "<p>順調</p>" in result
        assert "<p>最高の調子</p>" in result

    def test_htmlのbody要素で本文を囲む(self):
        report = HtmlReport()
        result = report.output_report()
        assert "<body>" in result
        assert "</body>" in result


class TestPlainTextReport:
    def test_プレーンテキスト形式でレポートを出力する(self):
        report = PlainTextReport()
        result = report.output_report()
        assert "***** 月次報告 *****" in result

    def test_プレーンテキストにテキスト行を含む(self):
        report = PlainTextReport()
        result = report.output_report()
        assert "順調" in result
        assert "最高の調子" in result


class TestReportBaseClass:
    def test_基底クラスを直接インスタンス化できない(self):
        with pytest.raises(TypeError):
            Report()

    def test_カスタムテキストを設定できる(self):
        report = HtmlReport()
        report.text = ["カスタム行"]
        result = report.output_report()
        assert "<p>カスタム行</p>" in result
