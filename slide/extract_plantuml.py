"""Marp Markdown 内の PlantUML ブロックを抽出して個別 .puml に保存し、
.md を画像参照に置換した版を出力する。"""

from __future__ import annotations

import re
from pathlib import Path

HERE = Path(__file__).parent
SRC = HERE / "スライド.md"
DST_MD = HERE / "スライド.images.md"
IMG_DIR = HERE / "images"

START_RE = re.compile(r"^@(startuml|startmindmap)\b.*$", re.MULTILINE)
END_RE = re.compile(r"^@(enduml|endmindmap)\b.*$", re.MULTILINE)


def main() -> None:
    IMG_DIR.mkdir(exist_ok=True)
    text = SRC.read_text(encoding="utf-8")

    output_parts: list[str] = []
    cursor = 0
    index = 0

    while True:
        start = START_RE.search(text, cursor)
        if not start:
            output_parts.append(text[cursor:])
            break

        end = END_RE.search(text, start.end())
        if not end:
            raise RuntimeError(f"@end{{uml,mindmap}} not found after offset {start.start()}")

        index += 1
        block = text[start.start() : end.end()]
        puml_path = IMG_DIR / f"diagram-{index:02d}.puml"
        puml_path.write_text(block + "\n", encoding="utf-8")

        fence_open_re = re.compile(r"```[a-zA-Z]*\s*\n")
        fence_close_re = re.compile(r"\n```")
        before = text[cursor:start.start()]
        m_open = None
        for m in fence_open_re.finditer(before):
            m_open = m
        m_close = fence_close_re.search(text, end.end())

        if m_open and m_close:
            replace_start = cursor + m_open.start()
            replace_end = m_close.end()
            output_parts.append(text[cursor:replace_start])
            output_parts.append(f"![](images/diagram-{index:02d}.png)")
            cursor = replace_end
        else:
            output_parts.append(text[cursor : start.start()])
            output_parts.append(f"![](images/diagram-{index:02d}.png)")
            cursor = end.end()

    DST_MD.write_text("".join(output_parts), encoding="utf-8")
    print(f"Extracted {index} diagrams -> {IMG_DIR}")
    print(f"Wrote image-referencing markdown -> {DST_MD}")


if __name__ == "__main__":
    main()
