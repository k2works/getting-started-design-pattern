package builder

import (
	"strings"
	"testing"
)

func TestBuildDesktop(t *testing.T) {
	pc, err := DesktopBuilder().Build()
	if err != nil {
		t.Fatalf("Build 失敗: %v", err)
	}
	if pc.Display != "27インチ 4K" {
		t.Errorf("期待値 '27インチ 4K', 実際 %q", pc.Display)
	}
	if pc.Memory != 32 {
		t.Errorf("期待値 32, 実際 %d", pc.Memory)
	}
	if len(pc.Drives) != 2 {
		t.Errorf("期待値 2 ドライブ, 実際 %d", len(pc.Drives))
	}
}

func TestBuildLaptop(t *testing.T) {
	pc, err := LaptopBuilder().Build()
	if err != nil {
		t.Fatalf("Build 失敗: %v", err)
	}
	if pc.Display != "15インチ FHD" {
		t.Errorf("期待値 '15インチ FHD', 実際 %q", pc.Display)
	}
	if pc.Memory != 16 {
		t.Errorf("期待値 16, 実際 %d", pc.Memory)
	}
}

func TestBuildValidationMissingDisplay(t *testing.T) {
	_, err := NewComputerBuilder().
		SetMotherboard("ASUS").
		SetMemory(16).
		Build()

	if err == nil {
		t.Error("ディスプレイなしでエラーが返るべき")
	}
}

func TestBuildValidationMissingMotherboard(t *testing.T) {
	_, err := NewComputerBuilder().
		SetDisplay("モニター").
		SetMemory(16).
		Build()

	if err == nil {
		t.Error("マザーボードなしでエラーが返るべき")
	}
}

func TestBuildValidationMissingMemory(t *testing.T) {
	_, err := NewComputerBuilder().
		SetDisplay("モニター").
		SetMotherboard("ASUS").
		Build()

	if err == nil {
		t.Error("メモリなしでエラーが返るべき")
	}
}

func TestMethodChaining(t *testing.T) {
	pc, err := NewComputerBuilder().
		SetDisplay("モニター").
		SetMotherboard("MSI").
		SetMemory(8).
		AddDrive("ssd", 128).
		Build()

	if err != nil {
		t.Fatalf("Build 失敗: %v", err)
	}
	if pc.Motherboard.Manufacturer != "MSI" {
		t.Errorf("期待値 'MSI', 実際 %q", pc.Motherboard.Manufacturer)
	}
}

func TestDescribe(t *testing.T) {
	pc, _ := DesktopBuilder().Build()
	desc := pc.Describe()

	if !strings.Contains(desc, "ディスプレイ") {
		t.Error("説明にディスプレイが含まれるべき")
	}
	if !strings.Contains(desc, "メモリ") {
		t.Error("説明にメモリが含まれるべき")
	}
}

func TestDriveString(t *testing.T) {
	d := Drive{Type: "ssd", Capacity: 512}
	if d.String() != "ssd 512GB" {
		t.Errorf("期待値 'ssd 512GB', 実際 %q", d.String())
	}
}
