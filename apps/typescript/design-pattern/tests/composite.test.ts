import {
  AddDryIngredientsTask,
  MakeBatterTask,
  MakeCakeTask,
  CompositeTask,
  PackageTask,
} from '../src/composite';

describe('Composite パターン', () => {
  it('リーフタスクは自身の時間を返す', () => {
    const task = new AddDryIngredientsTask();
    expect(task.getTimeRequired()).toBe(1.0);
  });

  it('MakeBatterTask は子タスクの合計時間を返す', () => {
    const batter = new MakeBatterTask();
    // AddDry(1.0) + AddLiquids(0.5) + Mix(3.0) = 4.5
    expect(batter.getTimeRequired()).toBe(4.5);
  });

  it('MakeCakeTask は全ての子タスクを含む合計時間を返す', () => {
    const cake = new MakeCakeTask();
    // Batter(4.5) + FillPan(0.5) + Bake(25) + Frost(10) + Package(5) = 45
    expect(cake.getTimeRequired()).toBe(45.0);
  });

  it('totalBasicTasks はリーフタスクの数を返す', () => {
    const cake = new MakeCakeTask();
    // AddDry + AddLiquids + Mix + FillPan + Bake + Frost + Package = 7
    expect(cake.totalBasicTasks()).toBe(7);
  });

  it('CompositeTask にサブタスクを追加・削除できる', () => {
    const composite = new CompositeTask('Test');
    const pkg = new PackageTask();
    composite.addSubTask(pkg);
    expect(composite.getTimeRequired()).toBe(5.0);

    composite.removeSubTask(pkg);
    expect(composite.getTimeRequired()).toBe(0);
  });

  it('リーフタスクの totalBasicTasks は 1 を返す', () => {
    const task = new AddDryIngredientsTask();
    expect(task.totalBasicTasks()).toBe(1);
  });
});
