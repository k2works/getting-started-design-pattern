package factory

import (
	"strings"
	"testing"
)

func TestDuck(t *testing.T) {
	duck := &Duck{DuckName: "ドナルド"}
	if duck.Speak() != "ガーガー" {
		t.Errorf("期待値 'ガーガー', 実際 %q", duck.Speak())
	}
	if duck.Name() != "ドナルド" {
		t.Errorf("期待値 'ドナルド', 実際 %q", duck.Name())
	}
}

func TestTiger(t *testing.T) {
	tiger := &Tiger{TigerName: "シェレカン"}
	if tiger.Speak() != "ガオー" {
		t.Errorf("期待値 'ガオー', 実際 %q", tiger.Speak())
	}
}

func TestWaterLily(t *testing.T) {
	lily := &WaterLily{LilyName: "スイレン"}
	if !strings.Contains(lily.Grow(), "水面に広がる") {
		t.Errorf("期待される成長メッセージが含まれていない: %q", lily.Grow())
	}
}

func TestPondFactory(t *testing.T) {
	f := PondFactory()
	animal := f.NewAnimal("テストアヒル")
	plant := f.NewPlant("テストスイレン")

	if _, ok := animal.(*Duck); !ok {
		t.Error("PondFactory は Duck を作成するべき")
	}
	if _, ok := plant.(*WaterLily); !ok {
		t.Error("PondFactory は WaterLily を作成するべき")
	}
}

func TestJungleFactory(t *testing.T) {
	f := JungleFactory()
	animal := f.NewAnimal("テストトラ")
	plant := f.NewPlant("テスト木")

	if _, ok := animal.(*Tiger); !ok {
		t.Error("JungleFactory は Tiger を作成するべき")
	}
	if _, ok := plant.(*Tree); !ok {
		t.Error("JungleFactory は Tree を作成するべき")
	}
}

func TestHabitat(t *testing.T) {
	habitat := NewHabitat(
		PondFactory(),
		[]string{"アヒル1", "アヒル2"},
		[]string{"スイレン1"},
	)

	if len(habitat.Animals) != 2 {
		t.Errorf("動物の数: 期待値 2, 実際 %d", len(habitat.Animals))
	}
	if len(habitat.Plants) != 1 {
		t.Errorf("植物の数: 期待値 1, 実際 %d", len(habitat.Plants))
	}
}

func TestHabitatDescribe(t *testing.T) {
	habitat := NewHabitat(
		PondFactory(),
		[]string{"アヒル"},
		[]string{"スイレン"},
	)
	desc := habitat.Describe()

	if !strings.Contains(desc, "ガーガー") {
		t.Error("説明にアヒルの鳴き声が含まれるべき")
	}
	if !strings.Contains(desc, "水面に広がる") {
		t.Error("説明にスイレンの成長が含まれるべき")
	}
}

func TestAnimalInterface(t *testing.T) {
	var _ Animal = &Duck{}
	var _ Animal = &Frog{}
	var _ Animal = &Tiger{}
}

func TestPlantInterface(t *testing.T) {
	var _ Plant = &WaterLily{}
	var _ Plant = &Algae{}
	var _ Plant = &Tree{}
}
