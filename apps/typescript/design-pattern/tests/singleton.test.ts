import { SingletonLogger, logger } from '../src/singleton';

describe('Singleton パターン', () => {
  beforeEach(() => {
    SingletonLogger.resetInstance();
  });

  it('getInstance は常に同一のインスタンスを返す', () => {
    const a = SingletonLogger.getInstance();
    const b = SingletonLogger.getInstance();
    expect(a).toBe(b);
  });

  it('メッセージをログに記録できる', () => {
    const log = SingletonLogger.getInstance();
    log.log('test message');
    expect(log.getLastMessage()).toBe('test message');
  });

  it('複数メッセージを記録して取得できる', () => {
    const log = SingletonLogger.getInstance();
    log.log('first');
    log.log('second');
    expect(log.getMessages()).toEqual(['first', 'second']);
  });

  it('clear でメッセージをクリアできる', () => {
    const log = SingletonLogger.getInstance();
    log.log('message');
    log.clear();
    expect(log.getMessages()).toEqual([]);
  });

  it('モジュールレベルの logger も SingletonLogger のインスタンスである', () => {
    expect(logger).toBeInstanceOf(SingletonLogger);
  });

  it('空の場合 getLastMessage は undefined を返す', () => {
    const log = SingletonLogger.getInstance();
    expect(log.getLastMessage()).toBeUndefined();
  });
});
