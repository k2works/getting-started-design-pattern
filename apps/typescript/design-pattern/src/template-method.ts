/**
 * Template Method パターン
 *
 * アルゴリズムの骨格を基底クラスで定義し、
 * 具体的なステップをサブクラスに委ねる。
 */

export abstract class Report {
  protected title: string;
  protected text: string[];

  constructor(title: string, text: string[]) {
    this.title = title;
    this.text = text;
  }

  /** テンプレートメソッド — 出力の骨格 */
  outputReport(): string {
    const parts: string[] = [];
    parts.push(this.outputStart());
    parts.push(this.outputHead());
    for (const line of this.text) {
      parts.push(this.outputLine(line));
    }
    parts.push(this.outputEnd());
    return parts.join('');
  }

  protected outputStart(): string {
    return '';
  }

  protected outputHead(): string {
    return this.title;
  }

  protected abstract outputLine(line: string): string;

  protected outputEnd(): string {
    return '';
  }
}

export class HtmlReport extends Report {
  protected outputStart(): string {
    return '<html>\n';
  }

  protected outputHead(): string {
    return `<head><title>${this.title}</title></head>\n<body>\n`;
  }

  protected outputLine(line: string): string {
    return `<p>${line}</p>\n`;
  }

  protected outputEnd(): string {
    return '</body>\n</html>\n';
  }
}

export class PlainTextReport extends Report {
  protected outputHead(): string {
    return `***** ${this.title} *****\n`;
  }

  protected outputLine(line: string): string {
    return `${line}\n`;
  }
}
