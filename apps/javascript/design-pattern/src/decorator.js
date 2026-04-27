// Decorator パターン
// オブジェクトに動的に責務を追加する

export class SimpleWriter {
  constructor() {
    this.contents = [];
  }

  writeLine(line) {
    this.contents.push(line);
  }

  getContents() {
    return this.contents.join('\n');
  }
}

// クラスベースの Decorator
export class NumberingWriter {
  constructor(writer) {
    this._writer = writer;
    this._lineNumber = 1;
  }

  writeLine(line) {
    this._writer.writeLine(`${this._lineNumber}: ${line}`);
    this._lineNumber++;
  }

  getContents() {
    return this._writer.getContents();
  }
}

export class TimeStampingWriter {
  constructor(writer) {
    this._writer = writer;
    this._getTime = () => new Date().toISOString();
  }

  // テスト用に時刻を固定できる
  setTimeProvider(fn) {
    this._getTime = fn;
  }

  writeLine(line) {
    this._writer.writeLine(`${this._getTime()} ${line}`);
  }

  getContents() {
    return this._writer.getContents();
  }
}

// 高階関数による Decorator
export function withNumbering(writer) {
  let lineNumber = 1;
  const originalWriteLine = writer.writeLine.bind(writer);
  writer.writeLine = (line) => {
    originalWriteLine(`${lineNumber}: ${line}`);
    lineNumber++;
  };
  return writer;
}

export function withTimeStamping(writer, timeProvider = () => new Date().toISOString()) {
  const originalWriteLine = writer.writeLine.bind(writer);
  writer.writeLine = (line) => {
    originalWriteLine(`${timeProvider()} ${line}`);
  };
  return writer;
}
