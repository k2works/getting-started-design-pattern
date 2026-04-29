import { describe, it, expect } from '@jest/globals';
import {
  SimpleWriter,
  NumberingWriter,
  TimeStampingWriter,
  withNumbering,
  withTimeStamping,
} from '../src/decorator.js';

describe('Decorator パターン', () => {
  describe('クラスベース', () => {
    it('SimpleWriter が行を書き込める', () => {
      const writer = new SimpleWriter();
      writer.writeLine('hello');
      writer.writeLine('world');
      expect(writer.getContents()).toBe('hello\nworld');
    });

    it('NumberingWriter が行番号を付与する', () => {
      const writer = new NumberingWriter(new SimpleWriter());
      writer.writeLine('hello');
      writer.writeLine('world');
      expect(writer.getContents()).toBe('1: hello\n2: world');
    });

    it('TimeStampingWriter がタイムスタンプを付与する', () => {
      const writer = new TimeStampingWriter(new SimpleWriter());
      writer.setTimeProvider(() => '2025-01-01T00:00:00Z');
      writer.writeLine('hello');
      expect(writer.getContents()).toBe('2025-01-01T00:00:00Z hello');
    });

    it('Decorator を重ねがけできる', () => {
      const writer = new NumberingWriter(new SimpleWriter());
      const timestamped = new TimeStampingWriter(writer);
      timestamped.setTimeProvider(() => '2025-01-01');
      timestamped.writeLine('hello');
      // タイムスタンプ → 番号付け の順で適用
      expect(timestamped.getContents()).toBe('1: 2025-01-01 hello');
    });
  });

  describe('高階関数ベース', () => {
    it('withNumbering が行番号を付与する', () => {
      const writer = withNumbering(new SimpleWriter());
      writer.writeLine('hello');
      writer.writeLine('world');
      expect(writer.getContents()).toBe('1: hello\n2: world');
    });

    it('withTimeStamping がタイムスタンプを付与する', () => {
      const writer = withTimeStamping(
        new SimpleWriter(),
        () => '2025-01-01T00:00:00Z'
      );
      writer.writeLine('hello');
      expect(writer.getContents()).toBe('2025-01-01T00:00:00Z hello');
    });

    it('高階関数 Decorator を重ねがけできる', () => {
      const writer = withTimeStamping(
        withNumbering(new SimpleWriter()),
        () => '2025-01-01'
      );
      writer.writeLine('hello');
      expect(writer.getContents()).toBe('1: 2025-01-01 hello');
    });
  });
});
