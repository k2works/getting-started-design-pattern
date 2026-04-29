// Command パターン
// 要求をオブジェクトとしてカプセル化し、実行・取り消しを可能にする

import { writeFileSync, unlinkSync, readFileSync, existsSync } from 'fs';

export class CreateFileCommand {
  constructor(filePath, content) {
    this.filePath = filePath;
    this.content = content;
    this.description = `ファイル作成: ${filePath}`;
  }

  execute() {
    writeFileSync(this.filePath, this.content, 'utf-8');
  }

  undo() {
    if (existsSync(this.filePath)) {
      unlinkSync(this.filePath);
    }
  }
}

export class DeleteFileCommand {
  constructor(filePath) {
    this.filePath = filePath;
    this.description = `ファイル削除: ${filePath}`;
    this._backup = null;
  }

  execute() {
    if (existsSync(this.filePath)) {
      this._backup = readFileSync(this.filePath, 'utf-8');
      unlinkSync(this.filePath);
    }
  }

  undo() {
    if (this._backup !== null) {
      writeFileSync(this.filePath, this._backup, 'utf-8');
    }
  }
}

export class CompositeCommand {
  constructor() {
    this.commands = [];
    this.description = 'コンポジットコマンド';
  }

  addCommand(command) {
    this.commands.push(command);
  }

  execute() {
    for (const command of this.commands) {
      command.execute();
    }
  }

  undo() {
    // 逆順に undo する
    for (const command of [...this.commands].reverse()) {
      command.undo();
    }
  }
}

export class SlickButton {
  constructor(callback) {
    this.callback = callback;
  }

  click() {
    this.callback();
  }
}
