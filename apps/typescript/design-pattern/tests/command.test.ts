import * as fs from 'fs';
import * as path from 'path';
import * as os from 'os';
import {
  CreateFileCommand,
  DeleteFileCommand,
  CompositeCommand,
} from '../src/command';

describe('Command パターン', () => {
  let tmpDir: string;

  beforeEach(() => {
    tmpDir = fs.mkdtempSync(path.join(os.tmpdir(), 'cmd-test-'));
  });

  afterEach(() => {
    fs.rmSync(tmpDir, { recursive: true, force: true });
  });

  it('CreateFileCommand はファイルを作成する', () => {
    const filePath = path.join(tmpDir, 'test.txt');
    const cmd = new CreateFileCommand(filePath, 'hello');
    cmd.execute();

    expect(fs.existsSync(filePath)).toBe(true);
    expect(fs.readFileSync(filePath, 'utf-8')).toBe('hello');
  });

  it('CreateFileCommand の undo はファイルを削除する', () => {
    const filePath = path.join(tmpDir, 'test.txt');
    const cmd = new CreateFileCommand(filePath, 'hello');
    cmd.execute();
    cmd.undo();

    expect(fs.existsSync(filePath)).toBe(false);
  });

  it('DeleteFileCommand はファイルを削除する', () => {
    const filePath = path.join(tmpDir, 'test.txt');
    fs.writeFileSync(filePath, 'content');
    const cmd = new DeleteFileCommand(filePath);
    cmd.execute();

    expect(fs.existsSync(filePath)).toBe(false);
  });

  it('DeleteFileCommand の undo はファイルを復元する', () => {
    const filePath = path.join(tmpDir, 'test.txt');
    fs.writeFileSync(filePath, 'content');
    const cmd = new DeleteFileCommand(filePath);
    cmd.execute();
    cmd.undo();

    expect(fs.existsSync(filePath)).toBe(true);
    expect(fs.readFileSync(filePath, 'utf-8')).toBe('content');
  });

  it('CompositeCommand は全コマンドを順番に実行する', () => {
    const file1 = path.join(tmpDir, 'a.txt');
    const file2 = path.join(tmpDir, 'b.txt');
    const composite = new CompositeCommand([
      new CreateFileCommand(file1, 'aaa'),
      new CreateFileCommand(file2, 'bbb'),
    ]);
    composite.execute();

    expect(fs.existsSync(file1)).toBe(true);
    expect(fs.existsSync(file2)).toBe(true);
  });

  it('CompositeCommand の undo は逆順に取り消す', () => {
    const file1 = path.join(tmpDir, 'a.txt');
    const file2 = path.join(tmpDir, 'b.txt');
    const composite = new CompositeCommand([
      new CreateFileCommand(file1, 'aaa'),
      new CreateFileCommand(file2, 'bbb'),
    ]);
    composite.execute();
    composite.undo();

    expect(fs.existsSync(file1)).toBe(false);
    expect(fs.existsSync(file2)).toBe(false);
  });

  it('Command は description を持つ', () => {
    const cmd = new CreateFileCommand('/tmp/x.txt', '');
    expect(cmd.description).toBe('Create file: x.txt');
  });
});
