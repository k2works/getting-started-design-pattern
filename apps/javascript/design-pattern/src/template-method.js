// Template Method パターン
// アルゴリズムの骨格を基底クラスで定義し、具体的なステップをサブクラスに委ねる

export class Report {
  constructor() {
    this.title = '月次報告';
    this.text = ['順調', '最高の調子'];
  }

  // テンプレートメソッド: レポート出力の骨格
  outputReport() {
    const lines = [];
    lines.push(...this.outputStart());
    lines.push(...this.outputHead());
    lines.push(...this.outputBodyStart());
    lines.push(...this.outputBody());
    lines.push(...this.outputBodyEnd());
    lines.push(...this.outputEnd());
    return lines.join('\n');
  }

  outputBody() {
    return this.text.flatMap((line) => this.outputLine(line));
  }

  // フックメソッド（デフォルトは何もしない）
  outputStart() { return []; }
  outputHead() { return this.outputLine(this.title); }
  outputBodyStart() { return []; }

  // 抽象メソッド
  outputLine(_line) {
    throw new Error('サブクラスで outputLine を実装してください');
  }

  outputBodyEnd() { return []; }
  outputEnd() { return []; }
}

export class HtmlReport extends Report {
  outputStart() { return ['<html>']; }
  outputHead() {
    return [' <head>', ` <title>${this.title}</title>`, ' </head>'];
  }
  outputBodyStart() { return ['<body>']; }
  outputLine(line) { return [` <p>${line}</p>`]; }
  outputBodyEnd() { return ['</body>']; }
  outputEnd() { return ['</html>']; }
}

export class PlainTextReport extends Report {
  outputHead() {
    return [`**** ${this.title} ****`, ''];
  }

  outputLine(line) {
    return [line];
  }
}
