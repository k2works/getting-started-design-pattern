package pattern.composite;

/**
 * 複合タスク: ケーキを作る
 */
public class MakeCakeTask extends CompositeTask {

    public MakeCakeTask() {
        super("ケーキを作る");
        addSubTask(new MakeBatterTask());
        addSubTask(new FillPanTask());
        addSubTask(new BakeTask());
        addSubTask(new FrostTask());
        addSubTask(new LickSpoonTask());
    }
}
