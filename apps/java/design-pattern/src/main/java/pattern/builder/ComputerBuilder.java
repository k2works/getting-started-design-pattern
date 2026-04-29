package pattern.builder;

import java.util.ArrayList;
import java.util.List;

/**
 * コンピュータビルダー基底クラス。
 * バリデーション: メモリ 250 以上、ドライブ 1-4 台、ハードディスク必須。
 */
public abstract class ComputerBuilder {
    protected boolean turbo = false;
    protected int memorySize = 512;
    protected final List<Drive> drives = new ArrayList<>();
    protected String display;

    public void setTurbo(boolean turbo) {
        this.turbo = turbo;
    }

    public void setMemorySize(int memorySize) {
        this.memorySize = memorySize;
    }

    public void addCd(boolean writable) {
        drives.add(new Drive("cd", 760, writable));
    }

    public void addDvd(boolean writable) {
        drives.add(new Drive("dvd", 4700, writable));
    }

    public void addHardDisk(int size) {
        drives.add(new Drive("hard_disk", size, true));
    }

    public Computer getComputer() {
        validate();
        String cpu = turbo ? "TurboCPU" : "BasicCPU";
        Motherboard motherboard = new Motherboard(cpu, memorySize);
        return new Computer(display, motherboard, List.copyOf(drives));
    }

    private void validate() {
        if (memorySize < 250) {
            throw new IllegalStateException("Not enough memory: " + memorySize);
        }
        if (drives.size() > 4) {
            throw new IllegalStateException("Too many drives: " + drives.size());
        }
        boolean hasHardDisk = drives.stream()
                .anyMatch(d -> "hard_disk".equals(d.type()));
        if (!hasHardDisk) {
            throw new IllegalStateException("Must have at least one hard disk");
        }
    }
}
