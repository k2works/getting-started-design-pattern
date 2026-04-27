import { describe, it, expect, beforeEach, afterEach } from '@jest/globals';
import { existsSync, readFileSync, writeFileSync, unlinkSync } from 'fs';
import { join } from 'path';
import { tmpdir } from 'os';
import {
  CreateFileCommand,
  DeleteFileCommand,
  CompositeCommand,
  SlickButton,
} from '../src/command.js';

describe('Command パターン', () => {
  const tempDir = tmpdir();
  const testFile = join(tempDir, 'command-test-file.txt');

  afterEach(() => {
    if (existsSync(testFile)) {
      unlinkSync(testFile);
    }
  });

  it('CreateFileCommand でファイルを作成できる', () => {
    const cmd = new CreateFileCommand(testFile, 'hello');
    cmd.execute();

    expect(existsSync(testFile)).toBe(true);
    expect(readFileSync(testFile, 'utf-8')).toBe('hello');
  });

  it('CreateFileCommand の undo でファイルを削除できる', () => {
    const cmd = new CreateFileCommand(testFile, 'hello');
    cmd.execute();
    cmd.undo();

    expect(existsSync(testFile)).toBe(false);
  });

  it('DeleteFileCommand でファイルを削除できる', () => {
    writeFileSync(testFile, 'backup-content', 'utf-8');
    const cmd = new DeleteFileCommand(testFile);
    cmd.execute();

    expect(existsSync(testFile)).toBe(false);
  });

  it('DeleteFileCommand の undo でファイルを復元できる', () => {
    writeFileSync(testFile, 'original', 'utf-8');
    const cmd = new DeleteFileCommand(testFile);
    cmd.execute();
    cmd.undo();

    expect(existsSync(testFile)).toBe(true);
    expect(readFileSync(testFile, 'utf-8')).toBe('original');
  });

  it('CompositeCommand で複数コマンドを一括実行できる', () => {
    const file1 = join(tempDir, 'cmd-comp-1.txt');
    const file2 = join(tempDir, 'cmd-comp-2.txt');

    const composite = new CompositeCommand();
    composite.addCommand(new CreateFileCommand(file1, 'one'));
    composite.addCommand(new CreateFileCommand(file2, 'two'));
    composite.execute();

    expect(existsSync(file1)).toBe(true);
    expect(existsSync(file2)).toBe(true);

    composite.undo();
    expect(existsSync(file1)).toBe(false);
    expect(existsSync(file2)).toBe(false);
  });

  it('SlickButton がコールバック関数を実行する', () => {
    let clicked = false;
    const button = new SlickButton(() => { clicked = true; });
    button.click();

    expect(clicked).toBe(true);
  });

  it('コマンドに説明文がある', () => {
    const cmd = new CreateFileCommand('/tmp/test.txt', '');
    expect(cmd.description).toContain('ファイル作成');
  });
});
