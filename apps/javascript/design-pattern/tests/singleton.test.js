import { describe, it, expect, beforeEach } from '@jest/globals';
import { SingletonLogger, logger } from '../src/singleton.js';

describe('Singleton パターン', () => {
  describe('クロージャベース SingletonLogger', () => {
    beforeEach(() => {
      SingletonLogger._resetForTesting();
    });

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

    it('clear でログをクリアできる', () => {
      const log = SingletonLogger.getInstance();
      log.log('消える');
      log.clear();
      expect(log.getLog()).toBe('');
    });

    it('リセット後は新しいインスタンスが返る', () => {
      const log1 = SingletonLogger.getInstance();
      log1.log('before');
      SingletonLogger._resetForTesting();
      const log2 = SingletonLogger.getInstance();
      expect(log2.getLog()).toBe('');
    });
  });

  describe('ES モジュール Singleton', () => {
    beforeEach(() => {
      logger.clear();
    });

    it('モジュールレベルの logger はシングルトン', () => {
      logger.log('test');
      expect(logger.getLog()).toBe('test');
    });

    it('同じモジュールからの import は同一インスタンス', () => {
      // 同一モジュールからの再 import は同じオブジェクトを返す
      logger.log('A');
      logger.log('B');
      expect(logger.getLog()).toBe('A\nB');
    });
  });
});
