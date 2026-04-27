/**
 * Interpreter パターン
 *
 * 言語の文法規則をクラス階層で表現し、
 * 文を解釈・実行する。
 */

import * as fs from 'fs';
import * as path from 'path';

export abstract class Expression {
  abstract evaluate(dir: string): string[];

  and(other: Expression): Expression {
    return new And(this, other);
  }

  or(other: Expression): Expression {
    return new Or(this, other);
  }
}

export class All extends Expression {
  evaluate(dir: string): string[] {
    if (!fs.existsSync(dir)) {
      return [];
    }
    return fs.readdirSync(dir).filter((f) => {
      const fullPath = path.join(dir, f);
      return fs.statSync(fullPath).isFile();
    });
  }
}

export class FileName extends Expression {
  private pattern: string;

  constructor(pattern: string) {
    super();
    this.pattern = pattern;
  }

  evaluate(dir: string): string[] {
    if (!fs.existsSync(dir)) {
      return [];
    }
    const regex = new RegExp(
      '^' + this.pattern.replace(/\./g, '\\.').replace(/\*/g, '.*') + '$'
    );
    return fs.readdirSync(dir).filter((f) => {
      const fullPath = path.join(dir, f);
      return fs.statSync(fullPath).isFile() && regex.test(f);
    });
  }
}

export class Bigger extends Expression {
  private sizeBytes: number;

  constructor(sizeBytes: number) {
    super();
    this.sizeBytes = sizeBytes;
  }

  evaluate(dir: string): string[] {
    if (!fs.existsSync(dir)) {
      return [];
    }
    return fs.readdirSync(dir).filter((f) => {
      const fullPath = path.join(dir, f);
      const stat = fs.statSync(fullPath);
      return stat.isFile() && stat.size > this.sizeBytes;
    });
  }
}

export class Not extends Expression {
  private expression: Expression;

  constructor(expression: Expression) {
    super();
    this.expression = expression;
  }

  evaluate(dir: string): string[] {
    const all = new All().evaluate(dir);
    const excluded = new Set(this.expression.evaluate(dir));
    return all.filter((f) => !excluded.has(f));
  }
}

export class And extends Expression {
  private left: Expression;
  private right: Expression;

  constructor(left: Expression, right: Expression) {
    super();
    this.left = left;
    this.right = right;
  }

  evaluate(dir: string): string[] {
    const leftResult = new Set(this.left.evaluate(dir));
    return this.right.evaluate(dir).filter((f) => leftResult.has(f));
  }
}

export class Or extends Expression {
  private left: Expression;
  private right: Expression;

  constructor(left: Expression, right: Expression) {
    super();
    this.left = left;
    this.right = right;
  }

  evaluate(dir: string): string[] {
    const combined = new Set([
      ...this.left.evaluate(dir),
      ...this.right.evaluate(dir),
    ]);
    return [...combined];
  }
}
