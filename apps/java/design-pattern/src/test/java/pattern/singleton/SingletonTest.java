package pattern.singleton;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertSame;
import static org.junit.jupiter.api.Assertions.assertTrue;

class SingletonTest {

    @Test
    void simpleLoggerLogsAtAllLevels() {
        SimpleLogger logger = new SimpleLogger();
        logger.error("err");
        logger.warning("warn");
        logger.info("inf");

        String content = logger.getLoggedContent();
        assertTrue(content.contains("[ERROR] err"));
        assertTrue(content.contains("[WARNING] warn"));
        assertTrue(content.contains("[INFO] inf"));
    }

    @Test
    void simpleLoggerRespectsLogLevel() {
        SimpleLogger logger = new SimpleLogger();
        logger.setLevel(SimpleLogger.ERROR);

        logger.error("visible");
        logger.warning("hidden");
        logger.info("hidden");

        String content = logger.getLoggedContent();
        assertTrue(content.contains("[ERROR] visible"));
        assertFalse(content.contains("[WARNING]"));
        assertFalse(content.contains("[INFO]"));
    }

    @Test
    void singletonLoggerReturnsSameInstance() {
        SingletonLogger a = SingletonLogger.getInstance();
        SingletonLogger b = SingletonLogger.getInstance();

        assertSame(a, b);
    }

    @Test
    void singletonLoggerCanLog() {
        SingletonLogger logger = SingletonLogger.getInstance();
        logger.setLevel(SimpleLogger.INFO);
        // Clear previous state by creating fresh — singleton shares state,
        // so we just verify it works
        logger.info("singleton test");

        assertTrue(logger.getLoggedContent().contains("[INFO] singleton test"));
    }

    @Test
    void enumLoggerIsSingleton() {
        LoggerEnum a = LoggerEnum.INSTANCE;
        LoggerEnum b = LoggerEnum.INSTANCE;

        assertSame(a, b);
    }

    @Test
    void enumLoggerLogsMessages() {
        LoggerEnum logger = LoggerEnum.INSTANCE;
        logger.setLevel(SimpleLogger.INFO);
        logger.info("enum test");

        assertTrue(logger.getLoggedContent().contains("[INFO] enum test"));
    }
}
