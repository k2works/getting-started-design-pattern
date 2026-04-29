/**
 * Composite パターン
 *
 * 個々のオブジェクトと複合オブジェクトを
 * 同一のインターフェースで扱う。
 */

export abstract class Task {
  protected name: string;

  constructor(name: string) {
    this.name = name;
  }

  getName(): string {
    return this.name;
  }

  abstract getTimeRequired(): number;

  totalBasicTasks(): number {
    return 1;
  }
}

export class AddDryIngredientsTask extends Task {
  constructor() {
    super('Add Dry Ingredients');
  }

  getTimeRequired(): number {
    return 1.0;
  }
}

export class AddLiquidsTask extends Task {
  constructor() {
    super('Add Liquids');
  }

  getTimeRequired(): number {
    return 0.5;
  }
}

export class MixTask extends Task {
  constructor() {
    super('Mix');
  }

  getTimeRequired(): number {
    return 3.0;
  }
}

export class FillPanTask extends Task {
  constructor() {
    super('Fill Pan');
  }

  getTimeRequired(): number {
    return 0.5;
  }
}

export class BakeTask extends Task {
  constructor() {
    super('Bake');
  }

  getTimeRequired(): number {
    return 25.0;
  }
}

export class FrostTask extends Task {
  constructor() {
    super('Frost');
  }

  getTimeRequired(): number {
    return 10.0;
  }
}

export class PackageTask extends Task {
  constructor() {
    super('Package');
  }

  getTimeRequired(): number {
    return 5.0;
  }
}

export class CompositeTask extends Task {
  protected subTasks: Task[] = [];

  addSubTask(task: Task): void {
    this.subTasks.push(task);
  }

  removeSubTask(task: Task): void {
    this.subTasks = this.subTasks.filter((t) => t !== task);
  }

  getSubTasks(): ReadonlyArray<Task> {
    return this.subTasks;
  }

  getTimeRequired(): number {
    return this.subTasks.reduce((sum, task) => sum + task.getTimeRequired(), 0);
  }

  totalBasicTasks(): number {
    return this.subTasks.reduce((sum, task) => sum + task.totalBasicTasks(), 0);
  }
}

export class MakeBatterTask extends CompositeTask {
  constructor() {
    super('Make Batter');
    this.addSubTask(new AddDryIngredientsTask());
    this.addSubTask(new AddLiquidsTask());
    this.addSubTask(new MixTask());
  }
}

export class MakeCakeTask extends CompositeTask {
  constructor() {
    super('Make Cake');
    this.addSubTask(new MakeBatterTask());
    this.addSubTask(new FillPanTask());
    this.addSubTask(new BakeTask());
    this.addSubTask(new FrostTask());
    this.addSubTask(new PackageTask());
  }
}
