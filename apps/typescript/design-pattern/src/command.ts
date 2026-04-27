/**
 * Command パターン
 *
 * 操作をオブジェクトとしてカプセル化し、
 * 実行・取り消しを可能にする。
 */

import * as fs from 'fs';
import * as path from 'path';

export interface Command {
  execute(): void;
  undo(): void;
  readonly description: string;
}

export class CreateFileCommand implements Command {
  private filePath: string;
  private contents: string;
  readonly description: string;

  constructor(filePath: string, contents: string) {
    this.filePath = filePath;
    this.contents = contents;
    this.description = `Create file: ${path.basename(filePath)}`;
  }

  execute(): void {
    fs.writeFileSync(this.filePath, this.contents, 'utf-8');
  }

  undo(): void {
    if (fs.existsSync(this.filePath)) {
      fs.unlinkSync(this.filePath);
    }
  }
}

export class DeleteFileCommand implements Command {
  private filePath: string;
  private savedContents: string | null = null;
  readonly description: string;

  constructor(filePath: string) {
    this.filePath = filePath;
    this.description = `Delete file: ${path.basename(filePath)}`;
  }

  execute(): void {
    if (fs.existsSync(this.filePath)) {
      this.savedContents = fs.readFileSync(this.filePath, 'utf-8');
      fs.unlinkSync(this.filePath);
    }
  }

  undo(): void {
    if (this.savedContents !== null) {
      fs.writeFileSync(this.filePath, this.savedContents, 'utf-8');
      this.savedContents = null;
    }
  }
}

export class CompositeCommand implements Command {
  private commands: Command[];
  readonly description: string;

  constructor(commands: Command[]) {
    this.commands = commands;
    this.description = `Composite(${commands.map((c) => c.description).join(', ')})`;
  }

  execute(): void {
    for (const command of this.commands) {
      command.execute();
    }
  }

  undo(): void {
    // undo in reverse order
    for (let i = this.commands.length - 1; i >= 0; i--) {
      this.commands[i].undo();
    }
  }
}
