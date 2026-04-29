# 第 9 章: Command

## はじめに

ファイルの作成・削除操作を「やり直し（undo）」可能にしたい。操作そのものをオブジェクトとしてカプセル化すれば、実行・取り消し・記録が統一的に行えます。

**Command パターン**は、要求（操作）をオブジェクトとしてカプセル化し、実行・取り消しを可能にするパターンです。

---

## パターンの構造

```plantuml
@startuml
title Command パターン

interface Command {
  + execute()
  + undo()
  + description : String
}

class CreateFileCommand {
  - filePath : String
  - content : String
  + execute()
  + undo()
}

class DeleteFileCommand {
  - filePath : String
  - _backup : String
  + execute()
  + undo()
}

class CompositeCommand {
  - commands : Array
  + addCommand(command)
  + execute()
  + undo()
}

class SlickButton {
  - callback : Function
  + click()
}

Command <|.. CreateFileCommand
Command <|.. DeleteFileCommand
Command <|.. CompositeCommand
CompositeCommand o-- "*" Command
@enduml
```

**登場人物**:

- **Command**: `execute()` / `undo()` のインターフェース
- **ConcreteCommand（CreateFileCommand 等）**: 具体的な操作
- **CompositeCommand**: 複数コマンドの一括実行
- **SlickButton**: コールバック関数を使った軽量 Command

---

## TDD で作る

### Red: テストを書く

```javascript
import { describe, it, expect, afterEach } from '@jest/globals';
import { existsSync, readFileSync, unlinkSync } from 'fs';
import { join } from 'path';
import { tmpdir } from 'os';
import { CreateFileCommand, DeleteFileCommand } from '../src/command.js';

describe('Command パターン', () => {
  const testFile = join(tmpdir(), 'command-test-file.txt');

  afterEach(() => {
    if (existsSync(testFile)) unlinkSync(testFile);
  });

  it('CreateFileCommand でファイルを作成できる', () => {
    const cmd = new CreateFileCommand(testFile, 'hello');
    cmd.execute();
    expect(existsSync(testFile)).toBe(true);
    expect(readFileSync(testFile, 'utf-8')).toBe('hello');
  });

  it('CreateFileCommand の undo でファイルを削除できる', () => {
    const cmd = new CreateFileCommand(testFile, 'hello');
    cmd.execute();
    cmd.undo();
    expect(existsSync(testFile)).toBe(false);
  });
});
```

### Green: 実装する

```javascript
import { writeFileSync, unlinkSync, readFileSync, existsSync } from 'fs';

export class CreateFileCommand {
  constructor(filePath, content) {
    this.filePath = filePath;
    this.content = content;
    this.description = `ファイル作成: ${filePath}`;
  }

  execute() { writeFileSync(this.filePath, this.content, 'utf-8'); }
  undo() {
    if (existsSync(this.filePath)) unlinkSync(this.filePath);
  }
}
```

#### DeleteFileCommand のバックアップ機構

`DeleteFileCommand` は `_backup` フィールドを持ち、`execute()` 時にファイル内容をバックアップします。`undo()` ではバックアップから復元します。

```javascript
export class DeleteFileCommand {
  constructor(filePath) {
    this.filePath = filePath;
    this.description = `ファイル削除: ${filePath}`;
    this._backup = null;
  }

  execute() {
    if (existsSync(this.filePath)) {
      this._backup = readFileSync(this.filePath, 'utf-8');
      unlinkSync(this.filePath);
    }
  }

  undo() {
    if (this._backup !== null) {
      writeFileSync(this.filePath, this._backup, 'utf-8');
    }
  }
}
```

```javascript
it('DeleteFileCommand の undo でファイルを復元できる', () => {
  writeFileSync(testFile, 'original', 'utf-8');
  const cmd = new DeleteFileCommand(testFile);
  cmd.execute();
  cmd.undo();

  expect(existsSync(testFile)).toBe(true);
  expect(readFileSync(testFile, 'utf-8')).toBe('original');
});
```

#### CompositeCommand の逆順 undo

`CompositeCommand` は複数のコマンドを一括で実行します。`undo()` では配列を **逆順** にして取り消すことで、操作の整合性を保ちます。

```javascript
export class CompositeCommand {
  constructor() {
    this.commands = [];
    this.description = 'コンポジットコマンド';
  }

  addCommand(command) { this.commands.push(command); }

  execute() {
    for (const command of this.commands) {
      command.execute();
    }
  }

  undo() {
    for (const command of [...this.commands].reverse()) {
      command.undo();
    }
  }
}
```

```javascript
it('CompositeCommand で複数コマンドを一括実行できる', () => {
  const file1 = join(tempDir, 'cmd-comp-1.txt');
  const file2 = join(tempDir, 'cmd-comp-2.txt');

  const composite = new CompositeCommand();
  composite.addCommand(new CreateFileCommand(file1, 'one'));
  composite.addCommand(new CreateFileCommand(file2, 'two'));
  composite.execute();

  expect(existsSync(file1)).toBe(true);
  expect(existsSync(file2)).toBe(true);

  composite.undo();
  expect(existsSync(file1)).toBe(false);
  expect(existsSync(file2)).toBe(false);
});
```

#### SlickButton: コールバック関数による軽量 Command

`SlickButton` はコマンドオブジェクトの代わりにコールバック関数を受け取る軽量な実装です。undo が不要な単純な操作に適しています。

```javascript
export class SlickButton {
  constructor(callback) {
    this.callback = callback;
  }

  click() {
    this.callback();
  }
}
```

```javascript
it('SlickButton がコールバック関数を実行する', () => {
  let clicked = false;
  const button = new SlickButton(() => { clicked = true; });
  button.click();

  expect(clicked).toBe(true);
});
```

### Refactor: 振り返り

- `CompositeCommand` は Composite パターンとの組み合わせです。`undo()` は `[...this.commands].reverse()` で逆順に実行し、操作の整合性を保ちます。
- `DeleteFileCommand` は `_backup` フィールドで削除前のファイル内容を保持し、`undo()` 時に復元する Memento 的なアプローチを採用しています。
- `SlickButton` は、JavaScript ではコマンドの代わりにコールバック関数を直接渡すことが多いことを示しています。

---

## Ruby / Java / Python との比較

| 観点 | Ruby | Java | Python | JavaScript |
|------|------|------|--------|------------|
| コマンド表現 | クラス or Proc | インターフェース + 実装 | クラス or callable | クラス or コールバック関数 |
| undo の実現 | インスタンス変数で状態保持 | Memento パターン併用 | インスタンス変数 | インスタンス変数 (`_backup`) |
| 軽量 Command | `Proc.new { }` | ラムダ式 | `lambda:` | `() => {}` |
| ファイル操作 | `File` クラス | `java.nio.file` | `pathlib` | `fs` モジュール |

**JavaScript の特徴**: コールバック関数が第一級オブジェクトなので、単純な Command は関数 1 つで表現できます（`SlickButton` の例）。undo が必要な場合はクラスベースの Command が適しています。

---

## まとめ

| 観点 | 内容 |
|------|------|
| **意図** | 要求をオブジェクトとしてカプセル化し、実行・取り消しを可能にする |
| **適用場面** | undo/redo、マクロ記録、キューイングが必要な場合 |
| **メリット** | 操作の実行タイミングと実行方法を分離できる |
| **注意点** | undo の正確な実装には状態の保存が必要 |
| **関連パターン** | Composite（コマンドの合成）、Memento（状態の保存・復元） |
