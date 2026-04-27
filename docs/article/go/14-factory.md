# 第 14 章: Factory

## はじめに

池（Pond）にはアヒルとスイレンが、ジャングルにはトラと木が住んでいます。生息地の種類に応じて適切な生物を生成したいとします。Factory パターンは、オブジェクト生成のロジックを分離するパターンです。

Go では interface + ファクトリ関数で実現します。

---

## パターンの構造

```plantuml
@startuml
title Factory パターン（Go 版）

interface Animal {
  + Name() : string
  + Eat() : string
  + Speak() : string
}

interface Plant {
  + Name() : string
  + Grow() : string
}

class <<struct>> Duck
class <<struct>> Frog
class <<struct>> Tiger

class <<struct>> WaterLily
class <<struct>> Algae
class <<struct>> Tree

class <<struct>> OrganismFactory {
  + NewAnimal : func(name string) Animal
  + NewPlant : func(name string) Plant
}

class <<struct>> Habitat {
  + Animals : []Animal
  + Plants : []Plant
  + Describe() : string
}

Animal <|.. Duck
Animal <|.. Frog
Animal <|.. Tiger
Plant <|.. WaterLily
Plant <|.. Algae
Plant <|.. Tree
Habitat --> OrganismFactory : uses
OrganismFactory --> Animal : creates
OrganismFactory --> Plant : creates
@enduml
```

---

## TDD で作る

### Red: テストを書く

```go
func TestPondFactory(t *testing.T) {
    f := PondFactory()
    animal := f.NewAnimal("テストアヒル")
    if _, ok := animal.(*Duck); !ok {
        t.Error("PondFactory は Duck を作成するべき")
    }
}

func TestHabitatDescribe(t *testing.T) {
    habitat := NewHabitat(PondFactory(), []string{"アヒル"}, []string{"スイレン"})
    desc := habitat.Describe()
    if !strings.Contains(desc, "ガーガー") {
        t.Error("説明にアヒルの鳴き声が含まれるべき")
    }
}
```

### Green: 実装する

```go
type OrganismFactory struct {
    NewAnimal func(name string) Animal
    NewPlant  func(name string) Plant
}

func PondFactory() *OrganismFactory {
    return &OrganismFactory{
        NewAnimal: func(name string) Animal { return &Duck{DuckName: name} },
        NewPlant:  func(name string) Plant { return &WaterLily{LilyName: name} },
    }
}
```

### Refactor: 振り返り

- ファクトリ関数フィールドを使うことで、abstract class なしにファクトリパターンを実現しています
- 新しい生息地は `OrganismFactory` を返す関数を追加するだけで拡張できます

---

## Ruby / Java / Python / JavaScript との比較

| 観点 | Ruby | Java | Python | JavaScript | Go |
|------|------|------|--------|------------|-----|
| Factory の型 | クラス | abstract class | ABC | クラス | struct + 関数フィールド |
| 生成メソッド | メソッド | abstract method | メソッド | メソッド | 関数フィールド |
| 生成物の型 | Duck Typing | interface | ABC | Duck Typing | interface |
| 拡張方法 | サブクラス | extends | 継承 | extends | 新しいファクトリ関数 |

---

## まとめ

| 観点 | 内容 |
|------|------|
| **意図** | オブジェクト生成のロジックを分離し、生成物の型を差し替え可能にする |
| **Go での実現** | 関数フィールドを持つ struct + interface |
| **メリット** | 継承なしで拡張可能、型安全 |
| **注意点** | ファクトリの種類が増えると管理が必要 |
| **関連パターン** | Builder（複雑な生成）、Singleton（単一インスタンス） |
