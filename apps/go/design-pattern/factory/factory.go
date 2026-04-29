// Package factory demonstrates the Factory pattern in Go.
// We use interfaces and factory functions instead of abstract classes.
package factory

import "fmt"

// Animal is the product interface for animals.
type Animal interface {
	Name() string
	Eat() string
	Speak() string
}

// Plant is the product interface for plants.
type Plant interface {
	Name() string
	Grow() string
}

// Duck is a concrete animal.
type Duck struct{ DuckName string }

func (d *Duck) Name() string  { return d.DuckName }
func (d *Duck) Eat() string   { return d.DuckName + " は虫を食べる" }
func (d *Duck) Speak() string { return "ガーガー" }

// Frog is a concrete animal.
type Frog struct{ FrogName string }

func (f *Frog) Name() string  { return f.FrogName }
func (f *Frog) Eat() string   { return f.FrogName + " は虫を食べる" }
func (f *Frog) Speak() string { return "ケロケロ" }

// Tiger is a concrete animal.
type Tiger struct{ TigerName string }

func (t *Tiger) Name() string  { return t.TigerName }
func (t *Tiger) Eat() string   { return t.TigerName + " は肉を食べる" }
func (t *Tiger) Speak() string { return "ガオー" }

// WaterLily is a concrete plant.
type WaterLily struct{ LilyName string }

func (w *WaterLily) Name() string { return w.LilyName }
func (w *WaterLily) Grow() string { return w.LilyName + " は水面に広がる" }

// Algae is a concrete plant.
type Algae struct{ AlgaeName string }

func (a *Algae) Name() string { return a.AlgaeName }
func (a *Algae) Grow() string { return a.AlgaeName + " は水中で増殖する" }

// Tree is a concrete plant.
type Tree struct{ TreeName string }

func (t *Tree) Name() string { return t.TreeName }
func (t *Tree) Grow() string { return t.TreeName + " は高く育つ" }

// OrganismFactory creates animals and plants.
type OrganismFactory struct {
	NewAnimal func(name string) Animal
	NewPlant  func(name string) Plant
}

// PondFactory returns a factory for pond organisms.
func PondFactory() *OrganismFactory {
	return &OrganismFactory{
		NewAnimal: func(name string) Animal { return &Duck{DuckName: name} },
		NewPlant:  func(name string) Plant { return &WaterLily{LilyName: name} },
	}
}

// JungleFactory returns a factory for jungle organisms.
func JungleFactory() *OrganismFactory {
	return &OrganismFactory{
		NewAnimal: func(name string) Animal { return &Tiger{TigerName: name} },
		NewPlant:  func(name string) Plant { return &Tree{TreeName: name} },
	}
}

// Habitat uses a factory to create and manage organisms.
type Habitat struct {
	Animals []Animal
	Plants  []Plant
	factory *OrganismFactory
}

// NewHabitat creates a habitat using the given factory.
func NewHabitat(factory *OrganismFactory, animalNames, plantNames []string) *Habitat {
	h := &Habitat{factory: factory}
	for _, name := range animalNames {
		h.Animals = append(h.Animals, factory.NewAnimal(name))
	}
	for _, name := range plantNames {
		h.Plants = append(h.Plants, factory.NewPlant(name))
	}
	return h
}

// Describe returns a description of the habitat.
func (h *Habitat) Describe() string {
	result := ""
	for _, a := range h.Animals {
		result += fmt.Sprintf("%s says %s\n", a.Name(), a.Speak())
	}
	for _, p := range h.Plants {
		result += fmt.Sprintf("%s\n", p.Grow())
	}
	return result
}
