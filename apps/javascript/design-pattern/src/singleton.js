// Singleton パターン
// クラスのインスタンスが 1 つだけであることを保証する

// クロージャベースの Singleton
export const SingletonLogger = (() => {
  let instance = null;

  class Logger {
    constructor() {
      this.logs = [];
    }

    log(message) {
      this.logs.push(message);
    }

    getLog() {
      return this.logs.join('\n');
    }

    clear() {
      this.logs = [];
    }
  }

  return {
    getInstance() {
      if (instance === null) {
        instance = new Logger();
      }
      return instance;
    },

    // テスト用リセット
    _resetForTesting() {
      instance = null;
    },
  };
})();

// ES モジュールパターン: モジュールスコープで 1 回だけ生成
class ModuleLogger {
  constructor() {
    this.logs = [];
  }

  log(message) {
    this.logs.push(message);
  }

  getLog() {
    return this.logs.join('\n');
  }

  clear() {
    this.logs = [];
  }
}

export const logger = new ModuleLogger();
