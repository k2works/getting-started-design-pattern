import * as fs from 'fs';
import * as path from 'path';
import * as os from 'os';
import { All, FileName, Bigger, Not, And, Or } from '../src/interpreter';

describe('Interpreter パターン', () => {
  let tmpDir: string;

  beforeEach(() => {
    tmpDir = fs.mkdtempSync(path.join(os.tmpdir(), 'interp-test-'));
    // Create test files
    fs.writeFileSync(path.join(tmpDir, 'small.txt'), 'hi');
    fs.writeFileSync(path.join(tmpDir, 'big.txt'), 'x'.repeat(200));
    fs.writeFileSync(path.join(tmpDir, 'photo.jpg'), 'fake-image-data');
    fs.writeFileSync(path.join(tmpDir, 'notes.md'), 'some notes here');
  });

  afterEach(() => {
    fs.rmSync(tmpDir, { recursive: true, force: true });
  });

  it('All は全ファイルを返す', () => {
    const result = new All().evaluate(tmpDir);
    expect(result).toHaveLength(4);
  });

  it('FileName はパターンに一致するファイルを返す', () => {
    const result = new FileName('*.txt').evaluate(tmpDir);
    expect(result.sort()).toEqual(['big.txt', 'small.txt']);
  });

  it('Bigger は指定サイズより大きいファイルを返す', () => {
    const result = new Bigger(100).evaluate(tmpDir);
    expect(result).toContain('big.txt');
    expect(result).not.toContain('small.txt');
  });

  it('Not は指定条件に一致しないファイルを返す', () => {
    const result = new Not(new FileName('*.txt')).evaluate(tmpDir);
    expect(result.sort()).toEqual(['notes.md', 'photo.jpg']);
  });

  it('And は両方の条件に一致するファイルを返す', () => {
    const expr = new FileName('*.txt').and(new Bigger(100));
    const result = expr.evaluate(tmpDir);
    expect(result).toEqual(['big.txt']);
  });

  it('Or はどちらかの条件に一致するファイルを返す', () => {
    const expr = new FileName('*.txt').or(new FileName('*.md'));
    const result = expr.evaluate(tmpDir);
    expect(result.sort()).toEqual(['big.txt', 'notes.md', 'small.txt']);
  });

  it('存在しないディレクトリでは空配列を返す', () => {
    const result = new All().evaluate('/nonexistent-path-12345');
    expect(result).toEqual([]);
  });
});
