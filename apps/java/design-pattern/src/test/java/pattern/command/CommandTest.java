package pattern.command;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.concurrent.atomic.AtomicReference;

import static org.junit.jupiter.api.Assertions.*;

class CommandTest {

    @TempDir
    Path tempDir;

    @Test
    void createFileCommandCreatesFile() throws IOException {
        Path file = tempDir.resolve("test.txt");
        Command cmd = new CreateFileCommand(file, "hello");

        cmd.execute();

        assertTrue(Files.exists(file));
        assertEquals("hello", Files.readString(file));
        assertEquals("Create file: " + file, cmd.getDescription());
    }

    @Test
    void createFileCommandUnexecuteDeletesFile() throws IOException {
        Path file = tempDir.resolve("test.txt");
        Command cmd = new CreateFileCommand(file, "hello");

        cmd.execute();
        assertTrue(Files.exists(file));

        cmd.unexecute();
        assertFalse(Files.exists(file));
    }

    @Test
    void deleteFileCommandDeletesAndRestoresFile() throws IOException {
        Path file = tempDir.resolve("existing.txt");
        Files.writeString(file, "original content");

        Command cmd = new DeleteFileCommand(file);

        cmd.execute();
        assertFalse(Files.exists(file));

        cmd.unexecute();
        assertTrue(Files.exists(file));
        assertEquals("original content", Files.readString(file));
    }

    @Test
    void compositeCommandExecutesAndUnexecutesInOrder() throws IOException {
        Path file1 = tempDir.resolve("file1.txt");
        Path file2 = tempDir.resolve("file2.txt");

        CompositeCommand composite = new CompositeCommand();
        composite.addCommand(new CreateFileCommand(file1, "content1"));
        composite.addCommand(new CreateFileCommand(file2, "content2"));

        composite.execute();
        assertTrue(Files.exists(file1));
        assertTrue(Files.exists(file2));

        String desc = composite.getDescription();
        assertTrue(desc.contains("Create file: " + file1));
        assertTrue(desc.contains("Create file: " + file2));

        composite.unexecute();
        assertFalse(Files.exists(file1));
        assertFalse(Files.exists(file2));
    }

    @Test
    void slickButtonExecutesLambdaCommand() {
        AtomicReference<String> result = new AtomicReference<>("");
        SlickButton button = new SlickButton(() -> result.set("clicked"));

        button.onButtonPush();

        assertEquals("clicked", result.get());
    }

    @Test
    void slickButtonHandlesNullCommand() {
        SlickButton button = new SlickButton(null);
        assertDoesNotThrow(button::onButtonPush);
    }
}
