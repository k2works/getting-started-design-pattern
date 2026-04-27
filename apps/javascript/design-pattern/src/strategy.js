// Strategy パターン
// アルゴリズムをオブジェクト（関数）として切り出し、実行時に差し替え可能にする

export class Report {
  constructor(formatter) {
    this.title = '月次報告';
    this.text = ['順調', '最高の調子'];
    this.formatter = formatter;
  }

  outputReport() {
    return this.formatter(this);
  }
}

export function htmlFormatter(report) {
  const lines = [
    '<html>',
    ' <head>',
    ` <title>${report.title}</title>`,
    ' </head>',
    '<body>',
    ...report.text.map((line) => ` <p>${line}</p>`),
    '</body>',
    '</html>',
  ];
  return lines.join('\n');
}

export function plainTextFormatter(report) {
  const lines = [
    `**** ${report.title} ****`,
    '',
    ...report.text,
  ];
  return lines.join('\n');
}
