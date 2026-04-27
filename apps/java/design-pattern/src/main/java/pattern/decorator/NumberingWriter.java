package pattern.decorator;

/**
 * 行番号付きデコレーター。
 * 各行の先頭に行番号を付与する。
 */
public class NumberingWriter extends WriterDecorator {
    private int lineNumber = 1;

    public NumberingWriter(Writer wrappedWriter) {
        super(wrappedWriter);
    }

    @Override
    public void writeLine(String line) {
        wrappedWriter.writeLine(lineNumber + ": " + line);
        lineNumber++;
    }
}
