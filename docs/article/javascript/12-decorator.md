# 第 12 章: Decorator

## はじめに

`SimpleWriter` に行番号やタイムスタンプを付与したいが、サブクラスを作ると組み合わせが爆発します。

**Decorator パターン**は、オブジェクトに動的に責務（機能）を追加するパターンです。JavaScript では、クラスベースの Decorator に加え、高階関数による関数的なアプローチも利用できます。

---

## パターンの構造

```plantuml
@startuml
title Decorator パターン

class SimpleWriter {
  - contents : Array
  + writeLine(line)
  + getContents() : String
}

class NumberingWriter {
  - _writer : SimpleWriter
  - _lineNumber : Number
  + writeLine(line)
  + getContents() : String
}

class TimeStampingWriter {
  - _writer : SimpleWriter
  - _getTime : Function
  + writeLine(line)
  + getContents() : String
}

SimpleWriter <|-- NumberingWriter : wraps
SimpleWriter <|-- TimeStampingWriter : wraps

note bottom of NumberingWriter
  クラスベース Decorator
end note

class <<module>> "withNumbering" as WN {
  + (writer) : writer
}

class <<module>> "withTimeStamping" as WT {
  + (writer, timeProvider) : writer
}

note bottom of WN
  高階関数 Decorator
end note
@enduml
```

**登場人物**:

- **Component（SimpleWriter）**: 基本的な振る舞いを提供する
- **Decorator（NumberingWriter / TimeStampingWriter）**: Component をラップして機能を追加する

---

## TDD で作る

### Red: テストを書く

```javascript
import { describe, it, expect } from '@jest/globals';
import { SimpleWriter, NumberingWriter, TimeStampingWriter } from '../src/decorator.js';

describe('Decorator パターン', () => {
  it('NumberingWriter が行番号を付与する', () => {
    const writer = new NumberingWriter(new SimpleWriter());
    writer.writeLine('hello');
    writer.writeLine('world');
    expect(writer.getContents()).toBe('1: hello\n2: world');
  });

  it('Decorator を重ねがけできる', () => {
    const writer = new NumberingWriter(new SimpleWriter());
    const timestamped = new TimeStampingWriter(writer);
    timestamped.setTimeProvider(() => '2025-01-01');
    timestamped.writeLine('hello');
    expect(timestamped.getContents()).toBe('1: 2025-01-01 hello');
  });
});
```

### Green: 実装する

```javascript
export class NumberingWriter {
  constructor(writer) {
    this._writer = writer;
    this._lineNumber = 1;
  }

  writeLine(line) {
    this._writer.writeLine(`${this._lineNumber}: ${line}`);
    this._lineNumber++;
  }

  getContents() { return this._writer.getContents(); }
}

// 高階関数版
export function withNumbering(writer) {
  let lineNumber = 1;
  const originalWriteLine = writer.writeLine.bind(writer);
  writer.writeLine = (line) => {
    originalWriteLine(`${lineNumber}: ${line}`);
    lineNumber++;
  };
  return writer;
}
```

### Refactor: 振り返り

- クラスベースの Decorator は、同じインターフェース（`writeLine` / `getContents`）を持つラッパーです。
- 高階関数版は、`writeLine` メソッドを直接置き換えます。新しいクラスを作らずに機能を追加できますが、元のオブジェクトを変更する副作用があります。

---

## Ruby / Java / Python との比較

| 観点 | Ruby | Java | Python | JavaScript |
|------|------|------|--------|------------|
| クラスベース | 委譲パターン | インターフェース + 委譲 | 委譲パターン | 委譲パターン |
| 動的 Decorator | `Module#prepend` | 不可 | `@decorator` 構文 | 高階関数 / Proxy |
| 関数 Decorator | Proc 合成 | 不可 | `@` 構文 | 高階関数 |
| メソッド置換 | `define_method` | 不可 | monkey patching | メソッド直接置換 |

**JavaScript の特徴**: 高階関数によるデコレーションは JavaScript の第一級関数の強みを活かしたアプローチです。クラスベースとは異なり、新しいクラスを定義せずに機能を追加できます。

---

## まとめ

| 観点 | 内容 |
|------|------|
| **意図** | オブジェクトに動的に責務を追加する |
| **適用場面** | 機能の組み合わせが多く、サブクラスの爆発を避けたい場合 |
| **メリット** | 機能の追加・削除が実行時に可能。組み合わせが自由 |
| **注意点** | ラッパーの層が深くなるとデバッグが困難 |
| **関連パターン** | Adapter（インターフェース変換）、Proxy（アクセス制御）、Composite（木構造） |
