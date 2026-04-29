package pattern.composite;

/**
 * 基底タスククラス（Composite パターン - Component）
 */
public class Task {

    private final String name;
    private CompositeTask parent;

    public Task(String name) {
        this.name = name;
    }

    public double getTimeRequired() {
        return 0.0;
    }

    public int getTotalBasicTasks() {
        return 1;
    }

    public String getName() {
        return name;
    }

    public CompositeTask getParent() {
        return parent;
    }

    public void setParent(CompositeTask parent) {
        this.parent = parent;
    }
}
