package pattern.decorator;

/**
 * ライターインターフェース（Component）。
 */
public interface Writer {
    void writeLine(String line);

    void close();
}
