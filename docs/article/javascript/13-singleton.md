# 第 13 章: Singleton

## はじめに

アプリケーション全体で 1 つだけのロガーインスタンスを共有したい。複数のインスタンスが生成されると、ログが分散して管理できなくなります。

**Singleton パターン**は、クラスのインスタンスが 1 つだけであることを保証し、そのグローバルなアクセス手段を提供するパターンです。

---

## パターンの構造

```plantuml
@startuml
title Singleton パターン

class <<module>> "SingletonLogger" as SL {
  - instance : Logger
  + getInstance() : Logger
  + _resetForTesting()
}

class Logger {
  - logs : Array
  + log(message)
  + getLog() : String
  + clear()
}

SL --> Logger : "lazily creates"

note right of SL
  クロージャベース:
  IIFE で instance を閉じ込める
end note

class <<module>> "logger (ES module)" as ML {
  - logs : Array
  + log(message)
  + getLog() : String
  + clear()
}

note right of ML
  ES モジュール自体が
  Singleton として機能
end note
@enduml
```

**2 つのアプローチ**:

1. **クロージャベース**: IIFE（即座実行関数式）で `instance` を閉じ込め、`getInstance()` で遅延生成する
2. **ES モジュールパターン**: モジュールスコープでインスタンスを生成し、`export` する

---

## TDD で作る

### Red: テストを書く

```javascript
import { describe, it, expect, beforeEach } from '@jest/globals';
import { SingletonLogger, logger } from '../src/singleton.js';

describe('Singleton パターン', () => {
  beforeEach(() => { SingletonLogger._resetForTesting(); });

  it('getInstance が常に同じインスタンスを返す', () => {
    const logger1 = SingletonLogger.getInstance();
    const logger2 = SingletonLogger.getInstance();
    expect(logger1).toBe(logger2);
  });

  it('ログを記録して取得できる', () => {
    const log = SingletonLogger.getInstance();
    log.log('メッセージ1');
    log.log('メッセージ2');
    expect(log.getLog()).toBe('メッセージ1\nメッセージ2');
  });
});
```

### Green: 実装する

```javascript
// クロージャベース
export const SingletonLogger = (() => {
  let instance = null;

  class Logger {
    constructor() { this.logs = []; }
    log(message) { this.logs.push(message); }
    getLog() { return this.logs.join('\n'); }
    clear() { this.logs = []; }
  }

  return {
    getInstance() {
      if (instance === null) instance = new Logger();
      return instance;
    },
    _resetForTesting() { instance = null; },
  };
})();

// ES モジュールパターン
class ModuleLogger {
  constructor() { this.logs = []; }
  log(message) { this.logs.push(message); }
  getLog() { return this.logs.join('\n'); }
  clear() { this.logs = []; }
}

export const logger = new ModuleLogger();
```

### Refactor: 振り返り

- **クロージャベース**: `Logger` クラスは IIFE のスコープ内に閉じ込められ、外部から直接 `new` できません。`_resetForTesting()` はテスト専用のリセット機能です。
- **ES モジュールパターン**: ES モジュールは一度だけ評価されるため、`export const logger = new ModuleLogger()` でモジュールレベルの Singleton が実現できます。最も JavaScript らしいアプローチです。

---

## Ruby / Java / Python との比較

| 観点 | Ruby | Java | Python | JavaScript |
|------|------|------|--------|------------|
| 古典的 Singleton | `Singleton` モジュール | `private` コンストラクタ | `__new__` オーバーライド | クロージャ + IIFE |
| モジュール Singleton | グローバル変数 | なし | モジュールレベル変数 | **ES モジュール export** |
| スレッドセーフ | `Mutex` | `synchronized` / enum | GIL で安全 | シングルスレッド |
| テスト時リセット | `instance_variable_set` | リフレクション | 変数再代入 | `_resetForTesting()` |

**JavaScript の特徴**: ES モジュールは一度だけ評価されるため、モジュールスコープで生成したインスタンスは自動的に Singleton になります。これは最もシンプルで推奨されるアプローチです。

---

## まとめ

| 観点 | 内容 |
|------|------|
| **意図** | クラスのインスタンスが 1 つだけであることを保証する |
| **適用場面** | ロガー、設定マネージャー、コネクションプールなど |
| **メリット** | グローバル状態の管理が統一される |
| **注意点** | テストが困難になりやすい。グローバル状態はバグの温床 |
| **関連パターン** | Factory（生成の管理）、Registry（名前による検索） |
