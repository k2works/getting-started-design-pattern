package designpattern.singleton

class SingletonSuite extends munit.FunSuite:
  override def beforeEach(context: BeforeEach): Unit =
    Logger.clear()
    AppConfig.reset()

  test("Logger はシングルトンである") {
    val logger1 = Logger
    val logger2 = Logger
    assert(logger1 eq logger2)
  }

  test("Logger にメッセージを記録する") {
    Logger.log("テスト開始")
    Logger.log("テスト終了")

    assertEquals(Logger.count, 2)
    assertEquals(Logger.messages, List("テスト開始", "テスト終了"))
  }

  test("Logger の lastMessage を取得する") {
    Logger.log("最初")
    Logger.log("最後")

    assertEquals(Logger.lastMessage, Some("最後"))
  }

  test("AppConfig はシングルトンである") {
    assertEquals(AppConfig.get("appName"), Some("DesignPatterns"))
  }

  test("AppConfig の設定を変更する") {
    AppConfig.set("debug", "true")
    assertEquals(AppConfig.get("debug"), Some("true"))
  }
