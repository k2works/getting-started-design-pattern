package pattern.singleton;

/**
 * Eager 初期化による Singleton ロガー。
 * private コンストラクタと static getInstance() でインスタンスを1つに制限する。
 */
public class SingletonLogger extends SimpleLogger {
    private static final SingletonLogger INSTANCE = new SingletonLogger();

    private SingletonLogger() {
    }

    public static SingletonLogger getInstance() {
        return INSTANCE;
    }
}
