/**
 * Singleton パターン
 *
 * クラスのインスタンスが1つだけ存在することを保証し、
 * グローバルなアクセスポイントを提供する。
 */

export class SingletonLogger {
  private static instance: SingletonLogger | null = null;
  private messages: string[] = [];

  private constructor() {}

  static getInstance(): SingletonLogger {
    if (SingletonLogger.instance === null) {
      SingletonLogger.instance = new SingletonLogger();
    }
    return SingletonLogger.instance;
  }

  /** テスト用: インスタンスをリセット */
  static resetInstance(): void {
    SingletonLogger.instance = null;
  }

  log(message: string): void {
    this.messages.push(message);
  }

  getMessages(): ReadonlyArray<string> {
    return this.messages;
  }

  getLastMessage(): string | undefined {
    return this.messages[this.messages.length - 1];
  }

  clear(): void {
    this.messages = [];
  }
}

/** モジュールレベルの Singleton インスタンス */
export const logger: SingletonLogger = SingletonLogger.getInstance();
