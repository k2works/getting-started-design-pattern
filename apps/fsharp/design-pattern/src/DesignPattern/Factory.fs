namespace DesignPattern.Factory

/// Factory パターン
/// F# では判別共用体でプロダクトの型を表現し、
/// ファクトリ関数でインスタンスを生成する。
module Factory =

    // --- 動物の判別共用体 ---

    type Habitat = Land | Water | Air

    type Animal =
        | Dog of name: string
        | Cat of name: string
        | Duck of name: string
        | Frog of name: string

    /// 動物の名前を取得する
    let animalName = function
        | Dog name | Cat name | Duck name | Frog name -> name

    /// 動物の鳴き声を取得する
    let animalSound = function
        | Dog _ -> "ワンワン"
        | Cat _ -> "ニャー"
        | Duck _ -> "ガーガー"
        | Frog _ -> "ケロケロ"

    /// 動物の生息地を取得する
    let animalHabitat = function
        | Dog _ | Cat _ -> Land
        | Duck _ -> Air
        | Frog _ -> Water

    // --- 植物の判別共用体 ---

    type Plant =
        | Algae of name: string
        | Tree of name: string * height: float
        | Flower of name: string * color: string

    /// 植物の名前を取得する
    let plantName = function
        | Algae name -> name
        | Tree(name, _) -> name
        | Flower(name, _) -> name

    /// 植物の説明を取得する
    let plantDescription = function
        | Algae name -> sprintf "%s は藻類です" name
        | Tree(name, height) -> sprintf "%s は高さ %.1f m の木です" name height
        | Flower(name, color) -> sprintf "%s は %s 色の花です" name color

    // --- ファクトリ関数 ---

    /// 文字列から動物を生成するファクトリ関数
    let createAnimal (animalType: string) (name: string) : Result<Animal, string> =
        match animalType.ToLower() with
        | "dog" -> Ok(Dog name)
        | "cat" -> Ok(Cat name)
        | "duck" -> Ok(Duck name)
        | "frog" -> Ok(Frog name)
        | unknown -> Error(sprintf "不明な動物タイプ: %s" unknown)

    /// 生息地から動物を生成するファクトリ関数
    let createAnimalByHabitat (habitat: Habitat) (name: string) : Animal =
        match habitat with
        | Land -> Dog name
        | Water -> Frog name
        | Air -> Duck name
