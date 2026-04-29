"""Template Method パターン

テンプレートメソッド output_report() が処理の骨格を定義し、
サブクラスが各ステップ（フックメソッド）をオーバーライドする。
"""

from abc import ABC, abstractmethod


class Report(ABC):
    """基底レポートクラス（Template Method パターン）"""

    def __init__(self) -> None:
        self.title: str = "月次報告"
        self.text: list[str] = ["順調", "最高の調子"]

    def output_report(self) -> str:
        """テンプレートメソッド: レポート出力の骨格"""
        parts: list[str] = []
        self._output_start(parts)
        self._output_head(parts)
        self._output_body_start(parts)
        self._output_body(parts)
        self._output_body_end(parts)
        self._output_end(parts)
        return "".join(parts)

    def _output_body(self, parts: list[str]) -> None:
        for line in self.text:
            self._output_line(parts, line)

    # フックメソッド（デフォルトは何もしない）
    def _output_start(self, parts: list[str]) -> None:
        pass

    def _output_head(self, parts: list[str]) -> None:
        self._output_line(parts, self.title)

    def _output_body_start(self, parts: list[str]) -> None:
        pass

    @abstractmethod
    def _output_line(self, parts: list[str], line: str) -> None:
        """抽象メソッド: サブクラスでオーバーライド必須"""

    def _output_body_end(self, parts: list[str]) -> None:
        pass

    def _output_end(self, parts: list[str]) -> None:
        pass


class HtmlReport(Report):
    """HTML 形式のレポート"""

    def _output_start(self, parts: list[str]) -> None:
        parts.append("<html>\n")

    def _output_head(self, parts: list[str]) -> None:
        parts.append(f"  <head><title>{self.title}</title></head>\n")

    def _output_body_start(self, parts: list[str]) -> None:
        parts.append("  <body>\n")

    def _output_line(self, parts: list[str], line: str) -> None:
        parts.append(f"    <p>{line}</p>\n")

    def _output_body_end(self, parts: list[str]) -> None:
        parts.append("  </body>\n")

    def _output_end(self, parts: list[str]) -> None:
        parts.append("</html>\n")


class PlainTextReport(Report):
    """プレーンテキスト形式のレポート"""

    def _output_head(self, parts: list[str]) -> None:
        parts.append(f"***** {self.title} *****\n")

    def _output_line(self, parts: list[str], line: str) -> None:
        parts.append(f"{line}\n")
