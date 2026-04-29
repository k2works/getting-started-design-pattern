// Package templatemethod demonstrates the Template Method pattern in Go.
// Go has no inheritance, so we use a struct with function fields to define
// the variable steps of an algorithm.
package templatemethod

import "strings"

// ReportFormat holds the configurable steps of the report algorithm.
// Each function field is a "hook" that concrete formats override.
type ReportFormat struct {
	OutputStart     func() []string
	OutputHead      func(title string) []string
	OutputBodyStart func() []string
	OutputLine      func(line string) []string
	OutputBodyEnd   func() []string
	OutputEnd       func() []string
}

// GenerateReport executes the template method algorithm using the given format.
func GenerateReport(format ReportFormat, title string, text []string) string {
	var lines []string

	if format.OutputStart != nil {
		lines = append(lines, format.OutputStart()...)
	}
	if format.OutputHead != nil {
		lines = append(lines, format.OutputHead(title)...)
	}
	if format.OutputBodyStart != nil {
		lines = append(lines, format.OutputBodyStart()...)
	}
	for _, t := range text {
		if format.OutputLine != nil {
			lines = append(lines, format.OutputLine(t)...)
		}
	}
	if format.OutputBodyEnd != nil {
		lines = append(lines, format.OutputBodyEnd()...)
	}
	if format.OutputEnd != nil {
		lines = append(lines, format.OutputEnd()...)
	}

	return strings.Join(lines, "\n")
}

// HtmlFormat returns a ReportFormat configured for HTML output.
func HtmlFormat() ReportFormat {
	return ReportFormat{
		OutputStart: func() []string { return []string{"<html>"} },
		OutputHead: func(title string) []string {
			return []string{" <head>", "  <title>" + title + "</title>", " </head>"}
		},
		OutputBodyStart: func() []string { return []string{"<body>"} },
		OutputLine: func(line string) []string {
			return []string{"  <p>" + line + "</p>"}
		},
		OutputBodyEnd: func() []string { return []string{"</body>"} },
		OutputEnd:     func() []string { return []string{"</html>"} },
	}
}

// PlainTextFormat returns a ReportFormat configured for plain text output.
func PlainTextFormat() ReportFormat {
	return ReportFormat{
		OutputHead: func(title string) []string {
			return []string{"**** " + title + " ****", ""}
		},
		OutputLine: func(line string) []string {
			return []string{line}
		},
	}
}
