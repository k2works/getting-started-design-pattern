/**
 * Decorator パターン
 *
 * 既存オブジェクトに動的に振る舞いを追加する。
 * 継承ではなく委譲で機能を拡張する。
 */

export interface Writer {
  writeLine(line: string): void;
  getOutput(): string;
}

export class SimpleWriter implements Writer {
  private lines: string[] = [];

  writeLine(line: string): void {
    this.lines.push(line);
  }

  getOutput(): string {
    return this.lines.join('\n');
  }
}

export class NumberingWriter implements Writer {
  private writer: Writer;
  private lineNumber = 0;

  constructor(writer: Writer) {
    this.writer = writer;
  }

  writeLine(line: string): void {
    this.lineNumber++;
    this.writer.writeLine(`${this.lineNumber}: ${line}`);
  }

  getOutput(): string {
    return this.writer.getOutput();
  }
}

export class TimeStampingWriter implements Writer {
  private writer: Writer;
  private clock: () => Date;

  constructor(writer: Writer, clock?: () => Date) {
    this.writer = writer;
    this.clock = clock ?? (() => new Date());
  }

  writeLine(line: string): void {
    const timestamp = this.clock().toISOString();
    this.writer.writeLine(`[${timestamp}] ${line}`);
  }

  getOutput(): string {
    return this.writer.getOutput();
  }
}
