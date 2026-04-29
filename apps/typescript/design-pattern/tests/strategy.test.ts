import { Report, htmlFormatter, plainTextFormatter } from '../src/strategy';

describe('Strategy パターン', () => {
  const title = 'Monthly Report';
  const text = ['Things are going', 'really really well.'];

  it('htmlFormatter は HTML 形式でフォーマットする', () => {
    const report = new Report(title, text, htmlFormatter);
    const output = report.outputReport();

    expect(output).toContain('<html>');
    expect(output).toContain(`<title>${title}</title>`);
    expect(output).toContain('<p>Things are going</p>');
  });

  it('plainTextFormatter はプレーンテキスト形式でフォーマットする', () => {
    const report = new Report(title, text, plainTextFormatter);
    const output = report.outputReport();

    expect(output).toContain(`***** ${title} *****`);
    expect(output).not.toContain('<html>');
  });

  it('実行時にフォーマッターを切り替えられる', () => {
    const report = new Report(title, text, htmlFormatter);
    expect(report.outputReport()).toContain('<html>');

    report.setFormatter(plainTextFormatter);
    expect(report.outputReport()).toContain('*****');
    expect(report.outputReport()).not.toContain('<html>');
  });

  it('カスタムフォーマッターを注入できる', () => {
    const csvFormatter = (t: string, lines: string[]) =>
      [t, ...lines].join(',');

    const report = new Report(title, text, csvFormatter);
    expect(report.outputReport()).toBe(
      'Monthly Report,Things are going,really really well.'
    );
  });
});
