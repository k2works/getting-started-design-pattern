package pattern.composite;

import java.util.ArrayList;
import java.util.List;

/**
 * 複合タスククラス（Composite パターン - Composite）
 */
public class CompositeTask extends Task {

    private final List<Task> subTasks = new ArrayList<>();

    public CompositeTask(String name) {
        super(name);
    }

    public void addSubTask(Task task) {
        subTasks.add(task);
        task.setParent(this);
    }

    public void removeSubTask(Task task) {
        subTasks.remove(task);
        task.setParent(null);
    }

    public Task getSubTask(int index) {
        return subTasks.get(index);
    }

    @Override
    public double getTimeRequired() {
        return subTasks.stream()
                .mapToDouble(Task::getTimeRequired)
                .sum();
    }

    @Override
    public int getTotalBasicTasks() {
        return subTasks.stream()
                .mapToInt(Task::getTotalBasicTasks)
                .sum();
    }
}
