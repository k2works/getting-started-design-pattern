using DesignPattern.Patterns.Singleton;

namespace DesignPattern.Tests.Patterns;

public class SingletonTest
{
    [Fact]
    public void SimpleLogger_LogsMessages()
    {
        var logger = new SimpleLogger();
        logger.Log("test message");

        Assert.Equal(1, logger.MessageCount);
        Assert.Equal("test message", logger.LatestMessage);
    }

    [Fact]
    public void SimpleLogger_MultipleInstances_AreIndependent()
    {
        var logger1 = new SimpleLogger();
        var logger2 = new SimpleLogger();
        logger1.Log("from logger1");

        Assert.Equal(1, logger1.MessageCount);
        Assert.Equal(0, logger2.MessageCount);
    }

    [Fact]
    public void SingletonLogger_ReturnsSameInstance()
    {
        var logger1 = SingletonLogger.Instance;
        var logger2 = SingletonLogger.Instance;

        Assert.Same(logger1, logger2);
    }

    [Fact]
    public void SingletonLogger_SharedState()
    {
        SingletonLogger.Instance.Reset();

        SingletonLogger.Instance.Log("shared message");

        Assert.Equal("shared message", SingletonLogger.Instance.LatestMessage);
        Assert.Equal(1, SingletonLogger.Instance.MessageCount);
    }

    [Fact]
    public void SingletonLogger_AccumulatesMessages()
    {
        SingletonLogger.Instance.Reset();

        SingletonLogger.Instance.Log("first");
        SingletonLogger.Instance.Log("second");

        Assert.Equal(2, SingletonLogger.Instance.MessageCount);
        Assert.Equal("second", SingletonLogger.Instance.LatestMessage);
    }
}
