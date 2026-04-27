"""Singleton パターンのテスト"""

from src.singleton import SingletonLogger, SingletonMeta, module_logger


class TestSingletonLogger:
    def setup_method(self):
        """各テスト前にインスタンスをリセット"""
        SingletonMeta._reset(SingletonLogger)

    def test_同じインスタンスが返される(self):
        logger1 = SingletonLogger()
        logger2 = SingletonLogger()
        assert logger1 is logger2

    def test_infoメッセージを記録できる(self):
        logger = SingletonLogger()
        logger.info("テストメッセージ")
        assert "[INFO] テストメッセージ" in logger.logged_content

    def test_warningメッセージを記録できる(self):
        logger = SingletonLogger()
        logger.warning("警告")
        assert "[WARNING] 警告" in logger.logged_content

    def test_errorメッセージを記録できる(self):
        logger = SingletonLogger()
        logger.error("エラー")
        assert "[ERROR] エラー" in logger.logged_content

    def test_レベル以下のメッセージは記録されない(self):
        logger = SingletonLogger()
        logger.level = SingletonLogger.ERROR
        logger.info("無視される")
        logger.warning("無視される")
        logger.error("記録される")
        assert "無視される" not in logger.logged_content
        assert "[ERROR] 記録される" in logger.logged_content


class TestModuleLogger:
    def setup_method(self):
        module_logger.clear()
        module_logger.level = module_logger.INFO

    def test_モジュールレベルのロガーが使える(self):
        module_logger.info("テスト")
        assert "[INFO] テスト" in module_logger.logged_content

    def test_モジュールレベルのロガーは同一インスタンス(self):
        from src.singleton import module_logger as logger2
        assert module_logger is logger2
