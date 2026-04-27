# Python 編 - デザインパターンからはじめるプログラミング入門

## 概要

Python のダックタイピング、デコレータ言語構文、ジェネレータ、プロトコルを活かして、GoF の 13 デザインパターンを TDD（pytest）で実装しながら学ぶ記事シリーズです。

**対象読者**: Python の基本文法を習得済みで、オブジェクト指向設計を深く理解したい開発者

**実装コード**: `apps/python/design-pattern/`

---

## スタイルガイド

### コード規約

- パッケージ: `src/{パターン名}/`（例: `src/template_method/`）
- テストファイル: `tests/test_{パターン名}.py`
- テストフレームワーク: pytest
- Python バージョン: 3.13

### 記事構成

各パターン章は以下の統一構成:

1. **はじめに** - パターンの動機
2. **パターンの構造** - PlantUML クラス図
3. **TDD で作る** - Red-Green-Refactor
4. **Ruby / Java との比較** - 3 言語の表現の違い
5. **まとめ** - 表形式のサマリー

---

## 目次

### 第 1 部: パターンとは何か

| 章 | タイトル |
|----|---------|
| 1 | [デザインパターンとパターン思考](01-introduction-to-patterns.md) |
| 2 | [パターンを支える基本原則](02-principles-and-patterns.md) |
| 3 | [開発環境と TDD 基盤](03-tdd-and-tooling.md) |

### 第 2 部: 振る舞いの取り扱い

| 章 | パターン | Python の特徴 |
|----|---------|--------------|
| 4 | [Template Method](04-template-method.md) | ABC + abstractmethod |
| 5 | [Strategy](05-strategy.md) | 関数（第一級オブジェクト） |
| 6 | [Observer](06-observer.md) | プロパティ + コールバック |
| 7 | [Composite](07-composite.md) | ダックタイピング |
| 8 | [Iterator](08-iterator.md) | \_\_iter\_\_ / ジェネレータ |

### 第 3 部: 操作と関係の表現

| 章 | パターン | Python の特徴 |
|----|---------|--------------|
| 9 | [Command](09-command.md) | callable オブジェクト |
| 10 | [Adapter](10-adapter.md) | ダックタイピング + ラッパー |
| 11 | [Proxy](11-proxy.md) | \_\_getattr\_\_ |
| 12 | [Decorator](12-decorator.md) | @decorator 言語構文 |

### 第 4 部: オブジェクトの作成と解釈

| 章 | パターン | Python の特徴 |
|----|---------|--------------|
| 13 | [Singleton](13-singleton.md) | メタクラス / モジュール |
| 14 | [Factory](14-factory.md) | クラスオブジェクト as ファクトリ |
| 15 | [Builder](15-builder.md) | dataclass + ビルダー |
| 16 | [Interpreter](16-interpreter.md) | pathlib + 演算子オーバーロード |
