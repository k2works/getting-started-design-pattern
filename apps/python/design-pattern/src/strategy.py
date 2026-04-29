"""Strategy パターン

フォーマット戦略を callable（関数/ラムダ）として受け取り、
出力処理を委譲する。
"""

from typing import Callable, Protocol


class ReportData(Protocol):
    """レポートデータのプロトコル"""

    @property
    def title(self) -> str: ...

    @property
    def text(self) -> list[str]: ...


class Report:
    """レポートクラス（Strategy パターン）"""

    def __init__(self, formatter: "Formatter") -> None:
        self._title: str = "月次報告"
        self._text: list[str] = ["順調", "最高の調子"]
        self.formatter = formatter

    @property
    def title(self) -> str:
        return self._title

    @property
    def text(self) -> list[str]:
        return list(self._text)

    def output_report(self) -> str:
        return self.formatter(self)


# 型エイリアス
Formatter = Callable[["Report"], str]


def html_formatter(report: Report) -> str:
    """HTML フォーマット戦略"""
    lines = [
        "<html>",
        f"  <head><title>{report.title}</title></head>",
        "  <body>",
    ]
    for line in report.text:
        lines.append(f"    <p>{line}</p>")
    lines.append("  </body>")
    lines.append("</html>")
    return "\n".join(lines) + "\n"


def plain_text_formatter(report: Report) -> str:
    """プレーンテキストフォーマット戦略"""
    lines = [f"***** {report.title} *****"]
    for line in report.text:
        lines.append(line)
    return "\n".join(lines) + "\n"
