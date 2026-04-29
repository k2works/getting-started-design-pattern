package adapter

import (
	"math"
	"strings"
	"testing"
)

func TestSimpleTextObject(t *testing.T) {
	obj := &SimpleTextObject{
		TextContent: "Hello",
		Size:        1.5,
		ColorValue:  "red",
	}

	if obj.Text() != "Hello" {
		t.Errorf("期待値 'Hello', 実際 %q", obj.Text())
	}
	if obj.SizeInches() != 1.5 {
		t.Errorf("期待値 1.5, 実際 %f", obj.SizeInches())
	}
	if obj.Color() != "red" {
		t.Errorf("期待値 'red', 実際 %q", obj.Color())
	}
}

func TestBritishTextObjectAdapter(t *testing.T) {
	british := &BritishTextObject{
		BritishText:   "Hello",
		SizeMillimeter: 25.4,
		Colour:        "red",
	}
	adapted := &BritishTextObjectAdapter{Object: british}

	if adapted.Text() != "Hello" {
		t.Errorf("期待値 'Hello', 実際 %q", adapted.Text())
	}
	if adapted.Color() != "red" {
		t.Errorf("期待値 'red', 実際 %q", adapted.Color())
	}
}

func TestMillimeterToInchConversion(t *testing.T) {
	british := &BritishTextObject{
		BritishText:   "Test",
		SizeMillimeter: 50.8,
		Colour:        "blue",
	}
	adapted := &BritishTextObjectAdapter{Object: british}

	expected := 2.0
	if math.Abs(adapted.SizeInches()-expected) > 0.001 {
		t.Errorf("期待値 %f, 実際 %f", expected, adapted.SizeInches())
	}
}

func TestRendererWithSimpleObject(t *testing.T) {
	renderer := &Renderer{}
	obj := &SimpleTextObject{
		TextContent: "Hello",
		Size:        1.0,
		ColorValue:  "blue",
	}
	output := renderer.Render(obj)

	if !strings.Contains(output, "Hello") {
		t.Error("出力にテキストが含まれていない")
	}
	if !strings.Contains(output, "blue") {
		t.Error("出力に色が含まれていない")
	}
}

func TestRendererWithAdapter(t *testing.T) {
	renderer := &Renderer{}
	british := &BritishTextObject{
		BritishText:   "Cheerio",
		SizeMillimeter: 25.4,
		Colour:        "crimson",
	}
	adapted := &BritishTextObjectAdapter{Object: british}
	output := renderer.Render(adapted)

	if !strings.Contains(output, "Cheerio") {
		t.Error("出力にテキストが含まれていない")
	}
	if !strings.Contains(output, "crimson") {
		t.Error("出力に色が含まれていない")
	}
	if !strings.Contains(output, "1.00in") {
		t.Errorf("出力にサイズが含まれていない: %s", output)
	}
}

func TestAdapterImplementsInterface(t *testing.T) {
	british := &BritishTextObject{
		BritishText:   "Test",
		SizeMillimeter: 25.4,
		Colour:        "green",
	}

	// Compile-time check that adapter satisfies TextObject interface
	var _ TextObject = &BritishTextObjectAdapter{Object: british}
}
