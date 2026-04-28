module DesignPattern.Tests.FactoryTests

open Xunit
open DesignPattern.Factory.Factory

[<Fact>]
let ``文字列から Dog を生成できる`` () =
    let result = createAnimal "dog" "ポチ"

    match result with
    | Ok(Dog name) -> Assert.Equal("ポチ", name)
    | _ -> Assert.Fail("Dog が期待される")

[<Fact>]
let ``文字列から Cat を生成できる`` () =
    let result = createAnimal "cat" "タマ"

    match result with
    | Ok(Cat name) -> Assert.Equal("タマ", name)
    | _ -> Assert.Fail("Cat が期待される")

[<Fact>]
let ``不明な動物タイプはエラーを返す`` () =
    let result = createAnimal "unicorn" "ユニ"

    match result with
    | Error msg -> Assert.Contains("不明な動物タイプ", msg)
    | Ok _ -> Assert.Fail("エラーが期待される")

[<Fact>]
let ``動物の鳴き声を取得できる`` () =
    Assert.Equal("ワンワン", animalSound (Dog "ポチ"))
    Assert.Equal("ニャー", animalSound (Cat "タマ"))
    Assert.Equal("ガーガー", animalSound (Duck "ガー子"))
    Assert.Equal("ケロケロ", animalSound (Frog "カエル太郎"))

[<Fact>]
let ``動物の生息地を取得できる`` () =
    Assert.Equal(Land, animalHabitat (Dog "ポチ"))
    Assert.Equal(Water, animalHabitat (Frog "カエル太郎"))
    Assert.Equal(Air, animalHabitat (Duck "ガー子"))

[<Fact>]
let ``生息地から動物を生成できる`` () =
    let landAnimal = createAnimalByHabitat Land "テスト"
    Assert.Equal(Land, animalHabitat landAnimal)

[<Fact>]
let ``植物の説明を取得できる`` () =
    let algae = Algae "ワカメ"
    let tree = Tree("桜", 10.5)
    let flower = Flower("バラ", "赤")
    Assert.Contains("藻類", plantDescription algae)
    Assert.Contains("10.5 m", plantDescription tree)
    Assert.Contains("赤", plantDescription flower)
