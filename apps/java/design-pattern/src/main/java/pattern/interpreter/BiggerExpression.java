package pattern.interpreter;

import java.io.IOException;
import java.io.UncheckedIOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;
import java.util.stream.Stream;

/**
 * 指定サイズより大きいファイルにマッチする式。
 */
public class BiggerExpression implements Expression {
    private final long size;

    public BiggerExpression(long size) {
        this.size = size;
    }

    @Override
    public List<Path> evaluate(Path dir) {
        try (Stream<Path> stream = Files.walk(dir)) {
            return stream
                    .filter(Files::isRegularFile)
                    .filter(p -> {
                        try {
                            return Files.size(p) > size;
                        } catch (IOException e) {
                            throw new UncheckedIOException(e);
                        }
                    })
                    .toList();
        } catch (IOException e) {
            throw new UncheckedIOException(e);
        }
    }
}
