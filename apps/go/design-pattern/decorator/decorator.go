// Package decorator demonstrates the Decorator pattern in Go.
// Decorators wrap a Writer interface, adding behavior transparently.
package decorator

import (
	"fmt"
	"strings"
	"time"
)

// Writer is the component interface.
type Writer interface {
	WriteLine(line string)
	Output() string
}

// SimpleWriter is the concrete component.
type SimpleWriter struct {
	lines []string
}

func NewSimpleWriter() *SimpleWriter {
	return &SimpleWriter{}
}

func (w *SimpleWriter) WriteLine(line string) {
	w.lines = append(w.lines, line)
}

func (w *SimpleWriter) Output() string {
	return strings.Join(w.lines, "\n")
}

// NumberingWriter is a decorator that adds line numbers.
type NumberingWriter struct {
	wrapped Writer
	count   int
	lines   []string
}

func NewNumberingWriter(wrapped Writer) *NumberingWriter {
	return &NumberingWriter{wrapped: wrapped}
}

func (n *NumberingWriter) WriteLine(line string) {
	n.count++
	numbered := fmt.Sprintf("%d: %s", n.count, line)
	n.wrapped.WriteLine(numbered)
	n.lines = append(n.lines, numbered)
}

func (n *NumberingWriter) Output() string {
	return n.wrapped.Output()
}

// TimeStampingWriter is a decorator that adds timestamps.
type TimeStampingWriter struct {
	wrapped Writer
	clock   func() time.Time
	lines   []string
}

// NewTimeStampingWriter creates a timestamping decorator.
// An optional clock function allows injecting a fake clock for testing.
func NewTimeStampingWriter(wrapped Writer, clock func() time.Time) *TimeStampingWriter {
	if clock == nil {
		clock = time.Now
	}
	return &TimeStampingWriter{wrapped: wrapped, clock: clock}
}

func (ts *TimeStampingWriter) WriteLine(line string) {
	stamped := fmt.Sprintf("%s %s", ts.clock().Format("2006-01-02 15:04:05"), line)
	ts.wrapped.WriteLine(stamped)
	ts.lines = append(ts.lines, stamped)
}

func (ts *TimeStampingWriter) Output() string {
	return ts.wrapped.Output()
}

// CheckingWriter is a decorator that validates line length.
type CheckingWriter struct {
	wrapped  Writer
	maxLen   int
	rejected []string
}

func NewCheckingWriter(wrapped Writer, maxLen int) *CheckingWriter {
	return &CheckingWriter{wrapped: wrapped, maxLen: maxLen}
}

func (c *CheckingWriter) WriteLine(line string) {
	if len(line) > c.maxLen {
		c.rejected = append(c.rejected, line)
		return
	}
	c.wrapped.WriteLine(line)
}

func (c *CheckingWriter) Output() string {
	return c.wrapped.Output()
}

// RejectedLines returns lines that were rejected due to length.
func (c *CheckingWriter) RejectedLines() []string {
	return c.rejected
}
