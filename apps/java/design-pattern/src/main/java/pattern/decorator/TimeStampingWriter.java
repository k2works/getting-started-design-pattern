package pattern.decorator;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * タイムスタンプ付きデコレーター。
 * 各行の先頭にタイムスタンプを付与する。
 */
public class TimeStampingWriter extends WriterDecorator {
    private static final DateTimeFormatter FORMATTER =
            DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    public TimeStampingWriter(Writer wrappedWriter) {
        super(wrappedWriter);
    }

    @Override
    public void writeLine(String line) {
        String timestamp = LocalDateTime.now().format(FORMATTER);
        wrappedWriter.writeLine(timestamp + ": " + line);
    }
}
