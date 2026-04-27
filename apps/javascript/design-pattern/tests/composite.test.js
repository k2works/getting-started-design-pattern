import { describe, it, expect } from '@jest/globals';
import {
  Task,
  CompositeTask,
  MakeBatterTask,
  MakeCakeTask,
  AddDryIngredientsTask,
  FillPanTask,
} from '../src/composite.js';

describe('Composite パターン', () => {
  it('リーフタスクの時間を返す', () => {
    const task = new AddDryIngredientsTask();
    expect(task.getTimeRequired()).toBe(1.0);
  });

  it('リーフタスクの totalBasicTasks は 1', () => {
    const task = new FillPanTask();
    expect(task.totalBasicTasks).toBe(1);
  });

  it('MakeBatterTask は子タスクの合計時間を返す', () => {
    const batter = new MakeBatterTask();
    // 1.0 + 0.5 + 3.0 = 4.5
    expect(batter.getTimeRequired()).toBe(4.5);
  });

  it('MakeBatterTask は 3 つの基本タスクを持つ', () => {
    const batter = new MakeBatterTask();
    expect(batter.totalBasicTasks).toBe(3);
  });

  it('MakeCakeTask は全工程の合計時間を返す', () => {
    const cake = new MakeCakeTask();
    // 4.5 + 0.5 + 30.0 + 5.0 + 0.1 = 40.1
    expect(cake.getTimeRequired()).toBeCloseTo(40.1);
  });

  it('MakeCakeTask は 7 つの基本タスクを持つ', () => {
    const cake = new MakeCakeTask();
    expect(cake.totalBasicTasks).toBe(7);
  });

  it('サブタスクを動的に追加・削除できる', () => {
    const composite = new CompositeTask('テスト');
    const task1 = new AddDryIngredientsTask();
    const task2 = new FillPanTask();

    composite.addSubTask(task1);
    composite.addSubTask(task2);
    expect(composite.getTimeRequired()).toBe(1.5);

    composite.removeSubTask(task1);
    expect(composite.getTimeRequired()).toBe(0.5);
  });

  it('基底クラス Task の getTimeRequired は例外を投げる', () => {
    const task = new Task('抽象タスク');
    expect(() => task.getTimeRequired()).toThrow();
  });
});
