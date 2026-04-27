package pattern.command;

import java.io.IOException;
import java.io.UncheckedIOException;
import java.nio.file.Files;
import java.nio.file.Path;

/**
 * ファイル作成コマンド。
 * execute でファイルを作成し、unexecute で削除する。
 */
public class CreateFileCommand implements Command {
    private final Path path;
    private final String contents;

    public CreateFileCommand(Path path, String contents) {
        this.path = path;
        this.contents = contents;
    }

    @Override
    public void execute() {
        try {
            Files.writeString(path, contents);
        } catch (IOException e) {
            throw new UncheckedIOException(e);
        }
    }

    @Override
    public void unexecute() {
        try {
            Files.deleteIfExists(path);
        } catch (IOException e) {
            throw new UncheckedIOException(e);
        }
    }

    @Override
    public String getDescription() {
        return "Create file: " + path;
    }
}
