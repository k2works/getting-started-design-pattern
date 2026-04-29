package pattern.builder;

/**
 * デスクトップビルダー。デフォルト CRT ディスプレイ。
 */
public class DesktopBuilder extends ComputerBuilder {
    public DesktopBuilder() {
        this.display = "CRT";
    }
}
