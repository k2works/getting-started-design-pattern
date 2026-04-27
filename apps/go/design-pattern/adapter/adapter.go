// Package adapter demonstrates the Adapter pattern in Go.
// We adapt a British text object (inches, colour) to a standard interface
// (centimeters, color).
package adapter

import "fmt"

// TextObject is the target interface that our system expects.
type TextObject interface {
	Text() string
	SizeInches() float64
	Color() string
}

// BritishTextObject is the adaptee — uses British conventions.
type BritishTextObject struct {
	BritishText   string
	SizeMillimeter float64
	Colour        string
}

// BritishTextObjectAdapter adapts BritishTextObject to the TextObject interface.
type BritishTextObjectAdapter struct {
	Object *BritishTextObject
}

func (a *BritishTextObjectAdapter) Text() string {
	return a.Object.BritishText
}

func (a *BritishTextObjectAdapter) SizeInches() float64 {
	return a.Object.SizeMillimeter / 25.4
}

func (a *BritishTextObjectAdapter) Color() string {
	return a.Object.Colour
}

// Renderer uses the TextObject interface to render text.
type Renderer struct{}

// Render produces a formatted string from a TextObject.
func (r *Renderer) Render(obj TextObject) string {
	return fmt.Sprintf("[%s] size=%.2fin color=%s", obj.Text(), obj.SizeInches(), obj.Color())
}

// SimpleTextObject is a direct implementation of TextObject.
type SimpleTextObject struct {
	TextContent string
	Size        float64
	ColorValue  string
}

func (s *SimpleTextObject) Text() string        { return s.TextContent }
func (s *SimpleTextObject) SizeInches() float64  { return s.Size }
func (s *SimpleTextObject) Color() string        { return s.ColorValue }
