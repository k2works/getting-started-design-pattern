package pattern.decorator;

/**
 * ライターデコレーター基底クラス。
 * デフォルトではすべての呼び出しを内部の Writer に委譲する。
 */
public class WriterDecorator implements Writer {
    protected final Writer wrappedWriter;

    public WriterDecorator(Writer wrappedWriter) {
        this.wrappedWriter = wrappedWriter;
    }

    @Override
    public void writeLine(String line) {
        wrappedWriter.writeLine(line);
    }

    @Override
    public void close() {
        wrappedWriter.close();
    }
}
