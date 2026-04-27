import { describe, it, expect, beforeEach, afterEach } from '@jest/globals';
import { mkdtempSync, writeFileSync, rmSync } from 'fs';
import { join } from 'path';
import { tmpdir } from 'os';
import { All, FileName, Bigger, And, Or, Not } from '../src/interpreter.js';

describe('Interpreter パターン', () => {
  let tempDir;

  beforeEach(() => {
    tempDir = mkdtempSync(join(tmpdir(), 'interp-'));
    writeFileSync(join(tempDir, 'report.txt'), 'A'.repeat(100));
    writeFileSync(join(tempDir, 'data.csv'), 'B'.repeat(5000));
    writeFileSync(join(tempDir, 'image.png'), 'C'.repeat(200));
    writeFileSync(join(tempDir, 'readme.txt'), 'D'.repeat(50));
  });

  afterEach(() => {
    rmSync(tempDir, { recursive: true, force: true });
  });

  it('All が全ファイルを返す', () => {
    const result = new All().evaluate(tempDir);
    expect(result).toHaveLength(4);
  });

  it('FileName がパターンに一致するファイルを返す', () => {
    const result = new FileName('\\.txt$').evaluate(tempDir);
    expect(result).toHaveLength(2);
    expect(result).toContain('report.txt');
    expect(result).toContain('readme.txt');
  });

  it('Bigger が指定サイズより大きいファイルを返す', () => {
    const result = new Bigger(150).evaluate(tempDir);
    expect(result).toHaveLength(2);
    expect(result).toContain('data.csv');
    expect(result).toContain('image.png');
  });

  it('And が両方の条件を満たすファイルを返す', () => {
    const expr = new And(new FileName('\\.txt$'), new Bigger(60));
    const result = expr.evaluate(tempDir);
    expect(result).toEqual(['report.txt']);
  });

  it('Or がどちらかの条件を満たすファイルを返す', () => {
    const expr = new Or(new FileName('\\.png$'), new FileName('\\.csv$'));
    const result = expr.evaluate(tempDir);
    expect(result).toHaveLength(2);
    expect(result).toContain('image.png');
    expect(result).toContain('data.csv');
  });

  it('Not が条件を満たさないファイルを返す', () => {
    const expr = new Not(new FileName('\\.txt$'));
    const result = expr.evaluate(tempDir);
    expect(result).toHaveLength(2);
    expect(result).toContain('data.csv');
    expect(result).toContain('image.png');
  });

  it('複合式を組み合わせられる', () => {
    // txt ファイルのうち 60 バイト以下のもの、または png ファイル
    const expr = new Or(
      new And(new FileName('\\.txt$'), new Not(new Bigger(60))),
      new FileName('\\.png$')
    );
    const result = expr.evaluate(tempDir);
    expect(result).toContain('readme.txt');
    expect(result).toContain('image.png');
    expect(result).not.toContain('data.csv');
  });
});
