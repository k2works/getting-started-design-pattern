package pattern.singleton;

/**
 * Enum ベースの Singleton（Effective Java スタイル）。
 * シリアライズやリフレクション攻撃に対しても安全。
 */
public enum LoggerEnum {
    INSTANCE;

    private final StringBuilder output = new StringBuilder();
    private int level = SimpleLogger.INFO;

    public void setLevel(int level) {
        this.level = level;
    }

    public void error(String msg) {
        if (level >= SimpleLogger.ERROR) {
            output.append("[ERROR] ").append(msg).append("\n");
        }
    }

    public void warning(String msg) {
        if (level >= SimpleLogger.WARNING) {
            output.append("[WARNING] ").append(msg).append("\n");
        }
    }

    public void info(String msg) {
        if (level >= SimpleLogger.INFO) {
            output.append("[INFO] ").append(msg).append("\n");
        }
    }

    public String getLoggedContent() {
        return output.toString();
    }
}
