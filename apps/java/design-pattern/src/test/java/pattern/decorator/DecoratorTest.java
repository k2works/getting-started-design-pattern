package pattern.decorator;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

class DecoratorTest {

    @Test
    void simpleWriterWritesLines() {
        SimpleWriter writer = new SimpleWriter();

        writer.writeLine("Hello");
        writer.writeLine("World");
        writer.close();

        assertEquals("Hello\nWorld\n", writer.getContents());
    }

    @Test
    void numberingWriterAddsLineNumbers() {
        SimpleWriter simple = new SimpleWriter();
        Writer writer = new NumberingWriter(simple);

        writer.writeLine("First");
        writer.writeLine("Second");
        writer.close();

        String contents = simple.getContents();
        assertTrue(contents.contains("1: First"));
        assertTrue(contents.contains("2: Second"));
    }

    @Test
    void timeStampingWriterAddsTimestamp() {
        SimpleWriter simple = new SimpleWriter();
        Writer writer = new TimeStampingWriter(simple);

        writer.writeLine("Event");
        writer.close();

        String contents = simple.getContents();
        assertTrue(contents.contains("Event"));
        // Timestamp format contains colons from time
        assertTrue(contents.matches("(?s).*\\d{4}-\\d{2}-\\d{2}.*Event.*"));
    }

    @Test
    void decoratorsCanBeStacked() {
        SimpleWriter simple = new SimpleWriter();
        Writer writer = new NumberingWriter(new TimeStampingWriter(simple));

        writer.writeLine("Line A");
        writer.writeLine("Line B");
        writer.close();

        String contents = simple.getContents();
        assertTrue(contents.contains("1: "));
        assertTrue(contents.contains("2: "));
        assertTrue(contents.contains("Line A"));
        assertTrue(contents.contains("Line B"));
    }

    @Test
    void writerDecoratorDelegatesToWrapped() {
        SimpleWriter simple = new SimpleWriter();
        WriterDecorator decorator = new WriterDecorator(simple);

        decorator.writeLine("delegated");
        decorator.close();

        assertEquals("delegated\n", simple.getContents());
    }
}
