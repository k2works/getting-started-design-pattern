// Composite パターン
// 個々のオブジェクトとその集合を同一視して扱う

export class Task {
  constructor(name) {
    this.name = name;
  }

  getTimeRequired() {
    throw new Error('サブクラスで getTimeRequired を実装してください');
  }

  get totalBasicTasks() {
    return 1;
  }
}

export class CompositeTask extends Task {
  constructor(name) {
    super(name);
    this.subTasks = [];
  }

  addSubTask(task) {
    this.subTasks.push(task);
  }

  removeSubTask(task) {
    this.subTasks = this.subTasks.filter((t) => t !== task);
  }

  getTimeRequired() {
    return this.subTasks.reduce((sum, task) => sum + task.getTimeRequired(), 0);
  }

  get totalBasicTasks() {
    return this.subTasks.reduce((sum, task) => sum + task.totalBasicTasks, 0);
  }
}

// リーフタスク
export class AddDryIngredientsTask extends Task {
  constructor() { super('乾燥材料を加える'); }
  getTimeRequired() { return 1.0; }
}

export class AddLiquidsTask extends Task {
  constructor() { super('液体を加える'); }
  getTimeRequired() { return 0.5; }
}

export class MixTask extends Task {
  constructor() { super('混ぜる'); }
  getTimeRequired() { return 3.0; }
}

export class FillPanTask extends Task {
  constructor() { super('型に流し込む'); }
  getTimeRequired() { return 0.5; }
}

export class BakeTask extends Task {
  constructor() { super('焼く'); }
  getTimeRequired() { return 30.0; }
}

export class FrostTask extends Task {
  constructor() { super('フロスティングする'); }
  getTimeRequired() { return 5.0; }
}

export class LickSpoonTask extends Task {
  constructor() { super('スプーンをなめる'); }
  getTimeRequired() { return 0.1; }
}

// コンポジットタスク
export class MakeBatterTask extends CompositeTask {
  constructor() {
    super('生地を作る');
    this.addSubTask(new AddDryIngredientsTask());
    this.addSubTask(new AddLiquidsTask());
    this.addSubTask(new MixTask());
  }
}

export class MakeCakeTask extends CompositeTask {
  constructor() {
    super('ケーキを作る');
    this.addSubTask(new MakeBatterTask());
    this.addSubTask(new FillPanTask());
    this.addSubTask(new BakeTask());
    this.addSubTask(new FrostTask());
    this.addSubTask(new LickSpoonTask());
  }
}
