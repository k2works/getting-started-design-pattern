package pattern.command;

import java.io.IOException;
import java.io.UncheckedIOException;
import java.nio.file.Files;
import java.nio.file.Path;

/**
 * ファイル削除コマンド。
 * execute でファイルを削除し、unexecute で復元する。
 */
public class DeleteFileCommand implements Command {
    private final Path path;
    private String savedContents;

    public DeleteFileCommand(Path path) {
        this.path = path;
    }

    @Override
    public void execute() {
        try {
            if (Files.exists(path)) {
                savedContents = Files.readString(path);
                Files.delete(path);
            }
        } catch (IOException e) {
            throw new UncheckedIOException(e);
        }
    }

    @Override
    public void unexecute() {
        try {
            if (savedContents != null) {
                Files.writeString(path, savedContents);
            }
        } catch (IOException e) {
            throw new UncheckedIOException(e);
        }
    }

    @Override
    public String getDescription() {
        return "Delete file: " + path;
    }
}
