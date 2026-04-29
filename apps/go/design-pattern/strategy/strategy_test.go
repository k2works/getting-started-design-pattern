package strategy

import (
	"strings"
	"testing"
)

func TestHtmlFormatter(t *testing.T) {
	report := &Report{
		Title:     "月次報告",
		Text:      []string{"順調", "最高の調子"},
		Formatter: HtmlFormatter,
	}
	output := report.Output()

	if !strings.Contains(output, "<html>") {
		t.Error("HTML 出力に <html> が含まれていない")
	}
	if !strings.Contains(output, "<title>月次報告</title>") {
		t.Error("HTML 出力にタイトルが含まれていない")
	}
	if !strings.Contains(output, "<p>順調</p>") {
		t.Error("HTML 出力に本文が含まれていない")
	}
}

func TestPlainTextFormatter(t *testing.T) {
	report := &Report{
		Title:     "月次報告",
		Text:      []string{"順調", "最高の調子"},
		Formatter: PlainTextFormatter,
	}
	output := report.Output()

	if !strings.Contains(output, "**** 月次報告 ****") {
		t.Error("プレーンテキスト出力にタイトルが含まれていない")
	}
	if strings.Contains(output, "<html>") {
		t.Error("プレーンテキスト出力に HTML タグが含まれている")
	}
}

func TestSwitchFormatter(t *testing.T) {
	report := &Report{
		Title:     "報告",
		Text:      []string{"内容"},
		Formatter: HtmlFormatter,
	}

	htmlOutput := report.Output()
	if !strings.Contains(htmlOutput, "<html>") {
		t.Error("初期フォーマッタが HTML ではない")
	}

	report.Formatter = PlainTextFormatter
	textOutput := report.Output()
	if strings.Contains(textOutput, "<html>") {
		t.Error("フォーマッタ切り替え後も HTML が出力されている")
	}
	if !strings.Contains(textOutput, "****") {
		t.Error("フォーマッタ切り替え後にプレーンテキストが出力されていない")
	}
}

func TestNilFormatter(t *testing.T) {
	report := &Report{
		Title: "報告",
		Text:  []string{"内容"},
	}
	output := report.Output()
	if output != "" {
		t.Error("nil フォーマッタで空文字列が返るべき")
	}
}

func TestCustomFormatter(t *testing.T) {
	markdown := func(title string, text []string) string {
		lines := []string{"# " + title, ""}
		for _, t := range text {
			lines = append(lines, "- "+t)
		}
		return strings.Join(lines, "\n")
	}

	report := &Report{
		Title:     "報告",
		Text:      []string{"項目1", "項目2"},
		Formatter: markdown,
	}
	output := report.Output()

	if !strings.Contains(output, "# 報告") {
		t.Error("カスタムフォーマッタのタイトルが正しくない")
	}
	if !strings.Contains(output, "- 項目1") {
		t.Error("カスタムフォーマッタの行が正しくない")
	}
}
