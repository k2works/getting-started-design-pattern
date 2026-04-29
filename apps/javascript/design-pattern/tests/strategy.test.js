import { describe, it, expect } from '@jest/globals';
import { Report, htmlFormatter, plainTextFormatter } from '../src/strategy.js';

describe('Strategy パターン', () => {
  it('htmlFormatter で HTML 形式のレポートを出力する', () => {
    const report = new Report(htmlFormatter);
    const output = report.outputReport();

    expect(output).toContain('<html>');
    expect(output).toContain('<title>月次報告</title>');
    expect(output).toContain('<p>順調</p>');
    expect(output).toContain('</html>');
  });

  it('plainTextFormatter でテキスト形式のレポートを出力する', () => {
    const report = new Report(plainTextFormatter);
    const output = report.outputReport();

    expect(output).toContain('**** 月次報告 ****');
    expect(output).toContain('順調');
    expect(output).not.toContain('<html>');
  });

  it('実行時にフォーマッタを差し替えられる', () => {
    const report = new Report(htmlFormatter);
    expect(report.outputReport()).toContain('<html>');

    report.formatter = plainTextFormatter;
    expect(report.outputReport()).toContain('****');
    expect(report.outputReport()).not.toContain('<html>');
  });

  it('アロー関数をカスタムフォーマッタとして渡せる', () => {
    const csvFormatter = (r) =>
      [r.title, ...r.text].join(',');

    const report = new Report(csvFormatter);
    expect(report.outputReport()).toBe('月次報告,順調,最高の調子');
  });

  it('フォーマッタが report オブジェクトにアクセスできる', () => {
    const upperFormatter = (r) =>
      r.text.map((t) => t.toUpperCase()).join('\n');

    const report = new Report(upperFormatter);
    // text はそのまま（大文字化はフォーマッタが行う）
    expect(report.text).toEqual(['順調', '最高の調子']);
  });
});
