import { HtmlReport, PlainTextReport } from '../src/template-method';

describe('Template Method パターン', () => {
  const title = 'Monthly Report';
  const text = ['Things are going', 'really really well.'];

  it('HtmlReport は HTML 形式で出力する', () => {
    const report = new HtmlReport(title, text);
    const output = report.outputReport();

    expect(output).toContain('<html>');
    expect(output).toContain(`<title>${title}</title>`);
    expect(output).toContain('<p>Things are going</p>');
    expect(output).toContain('</html>');
  });

  it('PlainTextReport はプレーンテキスト形式で出力する', () => {
    const report = new PlainTextReport(title, text);
    const output = report.outputReport();

    expect(output).toContain(`***** ${title} *****`);
    expect(output).toContain('Things are going');
    expect(output).not.toContain('<html>');
  });

  it('テンプレートメソッドは全てのステップを順番に呼び出す', () => {
    const report = new HtmlReport(title, text);
    const output = report.outputReport();
    const htmlIndex = output.indexOf('<html>');
    const headIndex = output.indexOf('<head>');
    const bodyEnd = output.indexOf('</html>');

    expect(htmlIndex).toBeLessThan(headIndex);
    expect(headIndex).toBeLessThan(bodyEnd);
  });

  it('PlainTextReport の各行は改行で区切られる', () => {
    const report = new PlainTextReport(title, text);
    const output = report.outputReport();
    const lines = output.split('\n').filter((l) => l.length > 0);

    expect(lines).toHaveLength(3); // title + 2 text lines
  });
});
