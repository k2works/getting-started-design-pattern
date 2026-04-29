package pattern.builder;

/**
 * ラップトップビルダー。デフォルト LCD ディスプレイ。
 */
public class LaptopBuilder extends ComputerBuilder {
    public LaptopBuilder() {
        this.display = "LCD";
    }
}
