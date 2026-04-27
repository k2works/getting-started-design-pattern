// Interpreter パターン
// 文法規則をクラス階層で表現し、文を解釈・評価する

import { statSync, readdirSync } from 'fs';
import { join, basename } from 'path';

// --- 式の基底クラス ---

export class Expression {
  evaluate(dir) {
    throw new Error('サブクラスで evaluate を実装してください');
  }
}

// --- 終端式（リーフ） ---

export class All extends Expression {
  evaluate(dir) {
    return readdirSync(dir);
  }
}

export class FileName extends Expression {
  constructor(pattern) {
    super();
    this.pattern = pattern;
  }

  evaluate(dir) {
    const regex = new RegExp(this.pattern);
    return readdirSync(dir).filter((file) => regex.test(file));
  }
}

export class Bigger extends Expression {
  constructor(sizeBytes) {
    super();
    this.sizeBytes = sizeBytes;
  }

  evaluate(dir) {
    return readdirSync(dir).filter((file) => {
      const filePath = join(dir, file);
      try {
        const stat = statSync(filePath);
        return stat.isFile() && stat.size > this.sizeBytes;
      } catch {
        return false;
      }
    });
  }
}

// --- 非終端式（複合） ---

export class And extends Expression {
  constructor(left, right) {
    super();
    this.left = left;
    this.right = right;
  }

  evaluate(dir) {
    const leftResult = new Set(this.left.evaluate(dir));
    return this.right.evaluate(dir).filter((file) => leftResult.has(file));
  }
}

export class Or extends Expression {
  constructor(left, right) {
    super();
    this.left = left;
    this.right = right;
  }

  evaluate(dir) {
    const result = new Set(this.left.evaluate(dir));
    for (const file of this.right.evaluate(dir)) {
      result.add(file);
    }
    return [...result];
  }
}

export class Not extends Expression {
  constructor(expression) {
    super();
    this.expression = expression;
  }

  evaluate(dir) {
    const allFiles = new Set(readdirSync(dir));
    const excluded = new Set(this.expression.evaluate(dir));
    return [...allFiles].filter((file) => !excluded.has(file));
  }
}
