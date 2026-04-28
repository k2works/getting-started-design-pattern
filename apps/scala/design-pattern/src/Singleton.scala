// Singleton パターン
// Scala の object はビルトインシングルトン

package designpattern.singleton

object Logger:
  private var _messages: List[String] = List.empty

  def log(message: String): Unit =
    _messages = _messages :+ message

  def messages: List[String] = _messages

  def lastMessage: Option[String] = _messages.lastOption

  def clear(): Unit =
    _messages = List.empty

  def count: Int = _messages.length

// object でシングルトンが保証されることを示すクラス
object AppConfig:

  private var _settings: Map[String, String] = Map(
    "appName" -> "DesignPatterns",
    "version" -> "1.0.0",
    "debug"   -> "false"
  )

  def get(key: String): Option[String] = _settings.get(key)

  def set(key: String, value: String): Unit =
    _settings = _settings + (key -> value)

  def reset(): Unit =
    _settings = Map(
      "appName" -> "DesignPatterns",
      "version" -> "1.0.0",
      "debug"   -> "false"
    )
