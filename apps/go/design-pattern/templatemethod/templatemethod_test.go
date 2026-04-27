package templatemethod

import (
	"strings"
	"testing"
)

func TestHtmlReport(t *testing.T) {
	output := GenerateReport(HtmlFormat(), "月次報告", []string{"順調", "最高の調子"})

	if !strings.Contains(output, "<html>") {
		t.Error("HTML 出力に <html> が含まれていない")
	}
	if !strings.Contains(output, "<title>月次報告</title>") {
		t.Error("HTML 出力にタイトルが含まれていない")
	}
	if !strings.Contains(output, "<p>順調</p>") {
		t.Error("HTML 出力に本文が含まれていない")
	}
	if !strings.Contains(output, "</html>") {
		t.Error("HTML 出力に </html> が含まれていない")
	}
}

func TestPlainTextReport(t *testing.T) {
	output := GenerateReport(PlainTextFormat(), "月次報告", []string{"順調", "最高の調子"})

	if !strings.Contains(output, "**** 月次報告 ****") {
		t.Error("プレーンテキスト出力にタイトルが含まれていない")
	}
	if !strings.Contains(output, "順調") {
		t.Error("プレーンテキスト出力に本文が含まれていない")
	}
	if strings.Contains(output, "<html>") {
		t.Error("プレーンテキスト出力に HTML タグが含まれている")
	}
}

func TestPlainTextReportContainsAllLines(t *testing.T) {
	output := GenerateReport(PlainTextFormat(), "月次報告", []string{"順調", "最高の調子"})

	if !strings.Contains(output, "最高の調子") {
		t.Error("プレーンテキスト出力にすべての行が含まれていない")
	}
}

func TestHtmlReportStructure(t *testing.T) {
	output := GenerateReport(HtmlFormat(), "テスト", []string{"行1"})
	lines := strings.Split(output, "\n")

	if lines[0] != "<html>" {
		t.Errorf("最初の行が <html> ではない: %s", lines[0])
	}
	if lines[len(lines)-1] != "</html>" {
		t.Errorf("最後の行が </html> ではない: %s", lines[len(lines)-1])
	}
}

func TestEmptyText(t *testing.T) {
	output := GenerateReport(HtmlFormat(), "空レポート", []string{})

	if !strings.Contains(output, "<html>") {
		t.Error("空のテキストでも HTML 構造が出力されるべき")
	}
	if !strings.Contains(output, "<title>空レポート</title>") {
		t.Error("空のテキストでもタイトルは出力されるべき")
	}
}

func TestCustomFormat(t *testing.T) {
	markdown := ReportFormat{
		OutputHead: func(title string) []string {
			return []string{"# " + title, ""}
		},
		OutputLine: func(line string) []string {
			return []string{"- " + line}
		},
	}

	output := GenerateReport(markdown, "報告", []string{"項目1", "項目2"})

	if !strings.Contains(output, "# 報告") {
		t.Error("カスタムフォーマットのタイトルが正しくない")
	}
	if !strings.Contains(output, "- 項目1") {
		t.Error("カスタムフォーマットの行が正しくない")
	}
}
