# 第 13 章: Singleton

## はじめに

アプリケーション全体で 1 つだけ存在すべきオブジェクトがあります。たとえばログ出力を担うロガーや、設定情報を保持する構成マネージャーです。これらのオブジェクトが複数のインスタンスを持つと、ログが分散したり設定の整合性が崩れたりします。

**Singleton パターン**は、クラスのインスタンスが 1 つだけであることを保証し、そのインスタンスへのグローバルなアクセスポイントを提供するパターンです。

---

## パターンの構造

```plantuml
@startuml
title Singleton パターン

class SimpleLogger {
  - output : StringIO
  - level : Integer
  + error(msg)
  + warning(msg)
  + info(msg)
  + logged_content() : String
}

class SingletonLogger {
  + {static} instance() : SingletonLogger
  - {static} new()
}

class ClassBasedLogger {
  - {static} @@log : StringIO
  - {static} @@level : Integer
  + {static} error(msg)
  + {static} warning(msg)
  + {static} info(msg)
  + {static} logged_content() : String
}

module ModuleBasedLogger {
  - @log : StringIO
  - @level : Integer
  + {static} error(msg)
  + {static} warning(msg)
  + {static} info(msg)
  + {static} logged_content() : String
}

SimpleLogger <|-- SingletonLogger : include Singleton
@enduml
```

---

## TDD で作る

### Red: テストを書く

まず、通常のロガーの振る舞いをテストで定義します。

```ruby
class SimpleLoggerTest < Minitest::Test
  def setup
    @logger = SimpleLogger.new
  end

  def test_default_level_is_info
    assert_equal SimpleLogger::INFO, @logger.level
  end

  def test_error_logs_at_error_level
    @logger.level = SimpleLogger::ERROR
    @logger.error("disk full")
    @logger.warning("should not appear")
    @logger.info("should not appear")

    assert_includes @logger.logged_content, "[ERROR] disk full"
    refute_includes @logger.logged_content, "[WARNING]"
    refute_includes @logger.logged_content, "[INFO]"
  end

  def test_info_logs_all_levels
    @logger.error("disk full")
    @logger.warning("low space")
    @logger.info("all is well")

    assert_includes @logger.logged_content, "[ERROR] disk full"
    assert_includes @logger.logged_content, "[WARNING] low space"
    assert_includes @logger.logged_content, "[INFO] all is well"
  end
end
```

次に、Singleton の核心部分をテストします。

```ruby
class SingletonLoggerTest < Minitest::Test
  def test_returns_same_instance
    logger1 = SingletonLogger.instance
    logger2 = SingletonLogger.instance

    assert_same logger1, logger2
  end

  def test_cannot_create_with_new
    assert_raises(NoMethodError) { SingletonLogger.new }
  end
end
```

`assert_same` はオブジェクトの同一性（`object_id` が同じ）を検証します。これが Singleton の本質です。

### Green: 実装する

**SimpleLogger（基本のロガー）**:

```ruby
require "stringio"

class SimpleLogger
  ERROR = 1
  WARNING = 2
  INFO = 3

  attr_accessor :level
  attr_reader :output

  def initialize
    @output = StringIO.new
    @level = INFO
  end

  def error(msg)
    @output.puts("[ERROR] #{msg}") if @level >= ERROR
  end

  def warning(msg)
    @output.puts("[WARNING] #{msg}") if @level >= WARNING
  end

  def info(msg)
    @output.puts("[INFO] #{msg}") if @level >= INFO
  end

  def logged_content
    @output.string
  end
end
```

テスト用に `StringIO` を使っています。ファイルやコンソールに依存しないため、テストが高速に動きます。

**SingletonLogger（Singleton モジュール利用）**:

```ruby
require "singleton"

class SingletonLogger < SimpleLogger
  include Singleton
end
```

`include Singleton` の一行で、`new` が private になり、`instance` メソッドが提供されます。Ruby の標準ライブラリがすべて面倒を見てくれます。

### Refactor: 設計を改善する

`SimpleLogger` と `SingletonLogger` を分離したことで、テストのしやすさと Singleton の保証を両立できています。テストでは `SimpleLogger.new` で毎回新しいインスタンスを作り、本番では `SingletonLogger.instance` で唯一のインスタンスを使います。

---

## Ruby らしい実装

Ruby では `Singleton` モジュール以外にも、Singleton 的な振る舞いを実現する方法があります。

**クラス変数ベース**:

```ruby
class ClassBasedLogger
  ERROR = 1
  WARNING = 2
  INFO = 3

  @@log = StringIO.new
  @@level = INFO

  def self.error(msg)
    @@log.puts("[ERROR] #{msg}") if @@level >= ERROR
  end

  def self.warning(msg)
    @@log.puts("[WARNING] #{msg}") if @@level >= WARNING
  end

  def self.info(msg)
    @@log.puts("[INFO] #{msg}") if @@level >= INFO
  end

  def self.logged_content
    @@log.string
  end
end
```

クラスメソッドだけで構成するため、インスタンスの概念自体が不要になります。ただしクラス変数 `@@` はサブクラスと共有されるため、継承時に意図しない共有が発生することがあります。

**モジュールベース**:

```ruby
module ModuleBasedLogger
  ERROR = 1
  WARNING = 2
  INFO = 3

  @log = StringIO.new
  @level = INFO

  def self.error(msg)
    @log.puts("[ERROR] #{msg}") if @level >= ERROR
  end

  def self.warning(msg)
    @log.puts("[WARNING] #{msg}") if @level >= WARNING
  end

  def self.info(msg)
    @log.puts("[INFO] #{msg}") if @level >= INFO
  end

  def self.logged_content
    @log.string
  end
end
```

モジュールはインスタンス化できないため、「唯一の存在」が言語レベルで保証されます。モジュールのインスタンス変数 `@` はそのモジュール固有のため、クラス変数 `@@` の継承問題もありません。

3 つのアプローチの使い分けは以下の通りです。

- **Singleton モジュール**: GoF の定義に忠実。遅延初期化が組み込みで提供される
- **クラス変数ベース**: シンプルだが、継承時のクラス変数共有に注意
- **モジュールベース**: 最も Ruby らしい方法。インスタンス化を言語レベルで防ぐ

---

## まとめ

| 観点 | 内容 |
|------|------|
| **意図** | クラスのインスタンスが 1 つだけであることを保証し、グローバルアクセスを提供する |
| **適用場面** | ロガー、設定マネージャー、データベース接続プールなど |
| **Singleton モジュール** | `include Singleton` で `new` を private 化し `instance` メソッドを提供 |
| **Ruby の強み** | Module 自体が Singleton として機能する。クラスメソッドだけで十分な場合も多い |
| **注意点** | グローバル状態はテストを困難にする。依存注入や `reset!` メソッドで対処する |
| **関連パターン** | Factory（生成の一元管理）、Flyweight（共有オブジェクト） |
