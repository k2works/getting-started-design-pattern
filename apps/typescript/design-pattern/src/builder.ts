/**
 * Builder パターン
 *
 * 複雑なオブジェクトの構築手順を分離し、
 * 同じ構築プロセスで異なる表現を生成する。
 */

export interface Drive {
  readonly type: 'hdd' | 'ssd';
  readonly sizeGb: number;
}

export interface Motherboard {
  readonly brand: string;
  readonly cpuSocket: string;
}

export interface Computer {
  readonly display: string;
  readonly motherboard: Motherboard;
  readonly drives: ReadonlyArray<Drive>;
  readonly memoryGb: number;
  readonly type: 'desktop' | 'laptop';
}

export class ComputerBuilder {
  protected display = '';
  protected motherboard: Motherboard | null = null;
  protected drives: Drive[] = [];
  protected memoryGb = 0;
  protected computerType: 'desktop' | 'laptop' = 'desktop';

  setDisplay(display: string): this {
    this.display = display;
    return this;
  }

  setMotherboard(brand: string, cpuSocket: string): this {
    this.motherboard = { brand, cpuSocket };
    return this;
  }

  addDrive(type: 'hdd' | 'ssd', sizeGb: number): this {
    this.drives.push({ type, sizeGb });
    return this;
  }

  setMemory(memoryGb: number): this {
    this.memoryGb = memoryGb;
    return this;
  }

  build(): Computer {
    if (!this.motherboard) {
      throw new Error('Motherboard is required');
    }
    if (this.drives.length === 0) {
      throw new Error('At least one drive is required');
    }
    if (this.memoryGb <= 0) {
      throw new Error('Memory must be greater than 0');
    }

    return {
      display: this.display,
      motherboard: this.motherboard,
      drives: [...this.drives],
      memoryGb: this.memoryGb,
      type: this.computerType,
    };
  }
}

export class DesktopBuilder extends ComputerBuilder {
  constructor() {
    super();
    this.computerType = 'desktop';
    this.display = '27-inch Monitor';
  }
}

export class LaptopBuilder extends ComputerBuilder {
  constructor() {
    super();
    this.computerType = 'laptop';
    this.display = '15-inch Retina';
  }
}
