package pattern.composite;

/**
 * 複合タスク: 生地を作る
 */
public class MakeBatterTask extends CompositeTask {

    public MakeBatterTask() {
        super("生地を作る");
        addSubTask(new AddDryIngredientsTask());
        addSubTask(new AddLiquidsTask());
        addSubTask(new MixTask());
    }
}
