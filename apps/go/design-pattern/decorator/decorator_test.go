package decorator

import (
	"strings"
	"testing"
	"time"
)

func TestSimpleWriter(t *testing.T) {
	w := NewSimpleWriter()
	w.WriteLine("hello")
	w.WriteLine("world")

	output := w.Output()
	if output != "hello\nworld" {
		t.Errorf("期待値 'hello\\nworld', 実際 %q", output)
	}
}

func TestNumberingWriter(t *testing.T) {
	w := NewSimpleWriter()
	nw := NewNumberingWriter(w)

	nw.WriteLine("hello")
	nw.WriteLine("world")

	output := nw.Output()
	if !strings.Contains(output, "1: hello") {
		t.Error("行番号 1 が含まれていない")
	}
	if !strings.Contains(output, "2: world") {
		t.Error("行番号 2 が含まれていない")
	}
}

func TestTimeStampingWriter(t *testing.T) {
	fixedTime := time.Date(2024, 1, 15, 10, 30, 0, 0, time.UTC)
	clock := func() time.Time { return fixedTime }

	w := NewSimpleWriter()
	tsw := NewTimeStampingWriter(w, clock)
	tsw.WriteLine("hello")

	output := tsw.Output()
	if !strings.Contains(output, "2024-01-15 10:30:00") {
		t.Errorf("タイムスタンプが含まれていない: %s", output)
	}
	if !strings.Contains(output, "hello") {
		t.Error("本文が含まれていない")
	}
}

func TestStackedDecorators(t *testing.T) {
	fixedTime := time.Date(2024, 1, 15, 10, 30, 0, 0, time.UTC)
	clock := func() time.Time { return fixedTime }

	w := NewSimpleWriter()
	nw := NewNumberingWriter(w)
	tsw := NewTimeStampingWriter(nw, clock)

	tsw.WriteLine("hello")

	output := tsw.Output()
	// TimeStamping wraps Numbering, so the output should be:
	// "1: 2024-01-15 10:30:00 hello"
	if !strings.Contains(output, "1:") {
		t.Error("行番号が含まれていない")
	}
	if !strings.Contains(output, "2024-01-15") {
		t.Error("タイムスタンプが含まれていない")
	}
}

func TestCheckingWriter(t *testing.T) {
	w := NewSimpleWriter()
	cw := NewCheckingWriter(w, 10)

	cw.WriteLine("short")
	cw.WriteLine("this is a very long line that exceeds the limit")

	output := cw.Output()
	if !strings.Contains(output, "short") {
		t.Error("短い行が含まれるべき")
	}
	if strings.Contains(output, "very long") {
		t.Error("長い行は含まれるべきではない")
	}
	if len(cw.RejectedLines()) != 1 {
		t.Errorf("拒否された行が 1 つであるべき、実際 %d", len(cw.RejectedLines()))
	}
}

func TestWriterInterface(t *testing.T) {
	// Compile-time interface checks
	var _ Writer = &SimpleWriter{}
	var _ Writer = &NumberingWriter{}
	var _ Writer = &TimeStampingWriter{}
	var _ Writer = &CheckingWriter{}
}
