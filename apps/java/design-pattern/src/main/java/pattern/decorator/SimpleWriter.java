package pattern.decorator;

/**
 * シンプルライター（Concrete Component）。
 * テスト容易性のために StringBuilder に書き込む。
 */
public class SimpleWriter implements Writer {
    private final StringBuilder buffer = new StringBuilder();

    @Override
    public void writeLine(String line) {
        buffer.append(line).append("\n");
    }

    @Override
    public void close() {
        // StringBuilder なので特に何もしない
    }

    public String getContents() {
        return buffer.toString();
    }
}
