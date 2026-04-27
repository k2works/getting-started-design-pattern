// Package strategy demonstrates the Strategy pattern in Go.
// Functions are first-class values in Go, so we use a function type
// as the strategy interface.
package strategy

import "strings"

// Formatter is a strategy function that formats a report.
type Formatter func(title string, text []string) string

// Report holds a title, text lines, and a formatting strategy.
type Report struct {
	Title     string
	Text      []string
	Formatter Formatter
}

// Output applies the formatter strategy to produce the report string.
func (r *Report) Output() string {
	if r.Formatter == nil {
		return ""
	}
	return r.Formatter(r.Title, r.Text)
}

// HtmlFormatter formats a report as HTML.
func HtmlFormatter(title string, text []string) string {
	var lines []string
	lines = append(lines, "<html>")
	lines = append(lines, " <head>")
	lines = append(lines, "  <title>"+title+"</title>")
	lines = append(lines, " </head>")
	lines = append(lines, "<body>")
	for _, t := range text {
		lines = append(lines, "  <p>"+t+"</p>")
	}
	lines = append(lines, "</body>")
	lines = append(lines, "</html>")
	return strings.Join(lines, "\n")
}

// PlainTextFormatter formats a report as plain text.
func PlainTextFormatter(title string, text []string) string {
	var lines []string
	lines = append(lines, "**** "+title+" ****")
	lines = append(lines, "")
	for _, t := range text {
		lines = append(lines, t)
	}
	return strings.Join(lines, "\n")
}
