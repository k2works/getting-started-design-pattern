import { describe, it, expect } from '@jest/globals';
import { Report, HtmlReport, PlainTextReport } from '../src/template-method.js';

describe('Template Method パターン', () => {
  it('HtmlReport が HTML 形式で出力する', () => {
    const report = new HtmlReport();
    const output = report.outputReport();

    expect(output).toContain('<html>');
    expect(output).toContain('<title>月次報告</title>');
    expect(output).toContain('<p>順調</p>');
    expect(output).toContain('<p>最高の調子</p>');
    expect(output).toContain('</html>');
  });

  it('PlainTextReport がプレーンテキスト形式で出力する', () => {
    const report = new PlainTextReport();
    const output = report.outputReport();

    expect(output).toContain('**** 月次報告 ****');
    expect(output).toContain('順調');
    expect(output).toContain('最高の調子');
    expect(output).not.toContain('<html>');
  });

  it('基底クラス Report の outputLine は例外を投げる', () => {
    const report = new Report();
    expect(() => report.outputReport()).toThrow('サブクラスで outputLine を実装してください');
  });

  it('HtmlReport の出力構造が正しい順序になっている', () => {
    const report = new HtmlReport();
    const output = report.outputReport();
    const lines = output.split('\n');

    expect(lines[0]).toBe('<html>');
    expect(lines[lines.length - 1]).toBe('</html>');
  });

  it('PlainTextReport はフックメソッドのデフォルトを利用する', () => {
    const report = new PlainTextReport();
    const output = report.outputReport();
    const lines = output.split('\n');

    // 空のフックメソッドにより、出力はタイトル + 空行 + 本文のみ
    expect(lines[0]).toBe('**** 月次報告 ****');
  });
});
