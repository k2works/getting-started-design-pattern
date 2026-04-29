package pattern.singleton;

/**
 * シンプルなログクラス。
 * テスト容易性のために StringBuilder に出力する。
 */
public class SimpleLogger {
    public static final int ERROR = 1;
    public static final int WARNING = 2;
    public static final int INFO = 3;

    private final StringBuilder output = new StringBuilder();
    private int level = INFO;

    public void setLevel(int level) {
        this.level = level;
    }

    public int getLevel() {
        return level;
    }

    public void error(String msg) {
        if (level >= ERROR) {
            output.append("[ERROR] ").append(msg).append("\n");
        }
    }

    public void warning(String msg) {
        if (level >= WARNING) {
            output.append("[WARNING] ").append(msg).append("\n");
        }
    }

    public void info(String msg) {
        if (level >= INFO) {
            output.append("[INFO] ").append(msg).append("\n");
        }
    }

    public String getLoggedContent() {
        return output.toString();
    }
}
