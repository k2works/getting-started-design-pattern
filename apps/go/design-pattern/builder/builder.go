// Package builder demonstrates the Builder pattern in Go.
// We use method chaining with a builder struct that returns (Computer, error).
package builder

import (
	"errors"
	"fmt"
	"strings"
)

// Drive represents a storage drive.
type Drive struct {
	Type     string // "hdd" or "ssd"
	Capacity int    // in GB
}

func (d Drive) String() string {
	return fmt.Sprintf("%s %dGB", d.Type, d.Capacity)
}

// Motherboard represents a motherboard.
type Motherboard struct {
	Manufacturer string
}

func (m Motherboard) String() string {
	return m.Manufacturer
}

// Computer is the product built by the builder.
type Computer struct {
	Display     string
	Motherboard Motherboard
	Drives      []Drive
	Memory      int // in GB
}

// Describe returns a human-readable description.
func (c *Computer) Describe() string {
	var parts []string
	parts = append(parts, fmt.Sprintf("ディスプレイ: %s", c.Display))
	parts = append(parts, fmt.Sprintf("マザーボード: %s", c.Motherboard))
	parts = append(parts, fmt.Sprintf("メモリ: %dGB", c.Memory))
	for _, d := range c.Drives {
		parts = append(parts, fmt.Sprintf("ドライブ: %s", d))
	}
	return strings.Join(parts, "\n")
}

// ComputerBuilder builds a Computer step by step using method chaining.
type ComputerBuilder struct {
	display     string
	motherboard Motherboard
	drives      []Drive
	memory      int
}

// NewComputerBuilder creates a new builder.
func NewComputerBuilder() *ComputerBuilder {
	return &ComputerBuilder{}
}

// SetDisplay sets the display.
func (b *ComputerBuilder) SetDisplay(display string) *ComputerBuilder {
	b.display = display
	return b
}

// SetMotherboard sets the motherboard.
func (b *ComputerBuilder) SetMotherboard(manufacturer string) *ComputerBuilder {
	b.motherboard = Motherboard{Manufacturer: manufacturer}
	return b
}

// AddDrive adds a drive.
func (b *ComputerBuilder) AddDrive(driveType string, capacity int) *ComputerBuilder {
	b.drives = append(b.drives, Drive{Type: driveType, Capacity: capacity})
	return b
}

// SetMemory sets the memory size.
func (b *ComputerBuilder) SetMemory(gb int) *ComputerBuilder {
	b.memory = gb
	return b
}

// Build creates the Computer, returning an error if required fields are missing.
func (b *ComputerBuilder) Build() (*Computer, error) {
	if b.display == "" {
		return nil, errors.New("ディスプレイは必須です")
	}
	if b.motherboard.Manufacturer == "" {
		return nil, errors.New("マザーボードは必須です")
	}
	if b.memory <= 0 {
		return nil, errors.New("メモリは 1GB 以上必須です")
	}

	return &Computer{
		Display:     b.display,
		Motherboard: b.motherboard,
		Drives:      b.drives,
		Memory:      b.memory,
	}, nil
}

// DesktopBuilder returns a builder pre-configured for a desktop.
func DesktopBuilder() *ComputerBuilder {
	return NewComputerBuilder().
		SetDisplay("27インチ 4K").
		SetMotherboard("ASUS").
		AddDrive("ssd", 512).
		AddDrive("hdd", 2000).
		SetMemory(32)
}

// LaptopBuilder returns a builder pre-configured for a laptop.
func LaptopBuilder() *ComputerBuilder {
	return NewComputerBuilder().
		SetDisplay("15インチ FHD").
		SetMotherboard("Intel").
		AddDrive("ssd", 256).
		SetMemory(16)
}
