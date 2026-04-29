// Builder パターン
// 複雑なオブジェクトの構築過程をカプセル化する

export class Drive {
  constructor(type, size) {
    this.type = type;    // 'hdd' | 'ssd'
    this.size = size;    // GB
  }

  toString() {
    return `${this.type.toUpperCase()} ${this.size}GB`;
  }
}

export class Motherboard {
  constructor(model) {
    this.model = model;
  }

  toString() {
    return `Motherboard: ${this.model}`;
  }
}

export class Computer {
  constructor() {
    this.display = null;
    this.motherboard = null;
    this.drives = [];
    this.memory = null;
  }

  toString() {
    const parts = [];
    if (this.display) parts.push(`Display: ${this.display}`);
    if (this.motherboard) parts.push(this.motherboard.toString());
    if (this.memory) parts.push(`Memory: ${this.memory}GB`);
    for (const drive of this.drives) {
      parts.push(`Drive: ${drive.toString()}`);
    }
    return parts.join(', ');
  }
}

export class ComputerBuilder {
  constructor() {
    this._computer = new Computer();
  }

  setDisplay(display) {
    this._computer.display = display;
    return this;
  }

  setMotherboard(model) {
    this._computer.motherboard = new Motherboard(model);
    return this;
  }

  addDrive(type, size) {
    this._computer.drives.push(new Drive(type, size));
    return this;
  }

  setMemory(sizeGb) {
    this._computer.memory = sizeGb;
    return this;
  }

  build() {
    if (!this._computer.motherboard) {
      throw new Error('マザーボードは必須です');
    }
    if (!this._computer.memory) {
      throw new Error('メモリは必須です');
    }
    return this._computer;
  }
}

export class DesktopBuilder extends ComputerBuilder {
  constructor() {
    super();
    this.setDisplay('27-inch 4K')
      .setMotherboard('ATX-Z790')
      .setMemory(32)
      .addDrive('ssd', 1000)
      .addDrive('hdd', 4000);
  }
}

export class LaptopBuilder extends ComputerBuilder {
  constructor() {
    super();
    this.setDisplay('15-inch Retina')
      .setMotherboard('Mobile-M2')
      .setMemory(16)
      .addDrive('ssd', 512);
  }
}
