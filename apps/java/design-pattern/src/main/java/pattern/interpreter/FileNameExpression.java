package pattern.interpreter;

import java.io.IOException;
import java.io.UncheckedIOException;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.PathMatcher;
import java.util.List;
import java.util.stream.Stream;

/**
 * ファイル名パターンでマッチする式。
 * glob パターンを使用する。
 */
public class FileNameExpression implements Expression {
    private final PathMatcher matcher;

    public FileNameExpression(String pattern) {
        this.matcher = FileSystems.getDefault().getPathMatcher("glob:" + pattern);
    }

    @Override
    public List<Path> evaluate(Path dir) {
        try (Stream<Path> stream = Files.walk(dir)) {
            return stream
                    .filter(Files::isRegularFile)
                    .filter(p -> matcher.matches(p.getFileName()))
                    .toList();
        } catch (IOException e) {
            throw new UncheckedIOException(e);
        }
    }
}
