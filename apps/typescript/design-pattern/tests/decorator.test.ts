import {
  SimpleWriter,
  NumberingWriter,
  TimeStampingWriter,
} from '../src/decorator';

describe('Decorator パターン', () => {
  it('SimpleWriter はそのまま出力する', () => {
    const writer = new SimpleWriter();
    writer.writeLine('hello');
    writer.writeLine('world');
    expect(writer.getOutput()).toBe('hello\nworld');
  });

  it('NumberingWriter は行番号を付与する', () => {
    const writer = new NumberingWriter(new SimpleWriter());
    writer.writeLine('hello');
    writer.writeLine('world');
    expect(writer.getOutput()).toBe('1: hello\n2: world');
  });

  it('TimeStampingWriter はタイムスタンプを付与する', () => {
    const fixedDate = new Date('2024-01-01T00:00:00.000Z');
    const writer = new TimeStampingWriter(new SimpleWriter(), () => fixedDate);
    writer.writeLine('hello');
    expect(writer.getOutput()).toBe('[2024-01-01T00:00:00.000Z] hello');
  });

  it('Decorator を重ねて適用できる', () => {
    const fixedDate = new Date('2024-01-01T00:00:00.000Z');
    const writer = new TimeStampingWriter(
      new NumberingWriter(new SimpleWriter()),
      () => fixedDate
    );
    writer.writeLine('hello');
    expect(writer.getOutput()).toBe(
      '1: [2024-01-01T00:00:00.000Z] hello'
    );
  });

  it('順序を変えると出力形式が変わる', () => {
    const fixedDate = new Date('2024-01-01T00:00:00.000Z');
    const writer = new NumberingWriter(
      new TimeStampingWriter(new SimpleWriter(), () => fixedDate)
    );
    writer.writeLine('hello');
    expect(writer.getOutput()).toBe(
      '[2024-01-01T00:00:00.000Z] 1: hello'
    );
  });
});
