/**
 * Strategy パターン
 *
 * アルゴリズムをオブジェクト（関数）として切り出し、
 * 実行時に差し替え可能にする。
 */

export type Formatter = (title: string, text: string[]) => string;

export const htmlFormatter: Formatter = (title, text) => {
  const lines = text.map((line) => `<p>${line}</p>`).join('\n');
  return `<html>\n<head><title>${title}</title></head>\n<body>\n${lines}\n</body>\n</html>`;
};

export const plainTextFormatter: Formatter = (title, text) => {
  const lines = text.map((line) => line).join('\n');
  return `***** ${title} *****\n${lines}`;
};

export class Report {
  private title: string;
  private text: string[];
  private formatter: Formatter;

  constructor(title: string, text: string[], formatter: Formatter) {
    this.title = title;
    this.text = text;
    this.formatter = formatter;
  }

  setFormatter(formatter: Formatter): void {
    this.formatter = formatter;
  }

  outputReport(): string {
    return this.formatter(this.title, this.text);
  }
}
