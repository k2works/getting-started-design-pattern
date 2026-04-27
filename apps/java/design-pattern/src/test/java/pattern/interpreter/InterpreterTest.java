package pattern.interpreter;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

class InterpreterTest {

    @TempDir
    Path tempDir;

    @BeforeEach
    void setUp() throws IOException {
        Files.writeString(tempDir.resolve("small.txt"), "hi");
        Files.writeString(tempDir.resolve("big.txt"), "x".repeat(2000));
        Files.writeString(tempDir.resolve("data.csv"), "a,b,c");
        Files.writeString(tempDir.resolve("image.jpg"), "fake image data here!!");
    }

    @Test
    void allExpressionFindsAllFiles() {
        Expression all = new AllExpression();
        List<Path> results = all.evaluate(tempDir);

        assertEquals(4, results.size());
    }

    @Test
    void fileNameExpressionMatchesPattern() {
        Expression expr = new FileNameExpression("*.txt");
        List<Path> results = expr.evaluate(tempDir);

        assertEquals(2, results.size());
        assertTrue(results.stream().allMatch(p -> p.toString().endsWith(".txt")));
    }

    @Test
    void biggerExpressionFiltersBySize() {
        Expression expr = new BiggerExpression(1000);
        List<Path> results = expr.evaluate(tempDir);

        assertEquals(1, results.size());
        assertTrue(results.get(0).getFileName().toString().equals("big.txt"));
    }

    @Test
    void andExpressionCombinesTwoExpressions() {
        Expression expr = new AndExpression(
                new FileNameExpression("*.txt"),
                new BiggerExpression(1000)
        );
        List<Path> results = expr.evaluate(tempDir);

        assertEquals(1, results.size());
        assertTrue(results.get(0).getFileName().toString().equals("big.txt"));
    }

    @Test
    void orExpressionUnitesTwoExpressions() {
        Expression expr = new OrExpression(
                new FileNameExpression("*.txt"),
                new FileNameExpression("*.csv")
        );
        List<Path> results = expr.evaluate(tempDir);

        assertEquals(3, results.size());
    }

    @Test
    void notExpressionExcludesMatches() {
        Expression expr = new NotExpression(new FileNameExpression("*.txt"));
        List<Path> results = expr.evaluate(tempDir);

        assertEquals(2, results.size());
        assertTrue(results.stream().noneMatch(p -> p.toString().endsWith(".txt")));
    }

    @Test
    void complexExpressionCombinesMultipleOperators() {
        // Find txt files that are NOT big
        Expression expr = new AndExpression(
                new FileNameExpression("*.txt"),
                new NotExpression(new BiggerExpression(1000))
        );
        List<Path> results = expr.evaluate(tempDir);

        assertEquals(1, results.size());
        assertEquals("small.txt", results.get(0).getFileName().toString());
    }
}
