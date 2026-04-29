package pattern.interpreter;

import java.nio.file.Path;
import java.util.List;

/**
 * 式インターフェース（Interpreter パターン）。
 * ディレクトリを評価し、条件に一致するファイルのリストを返す。
 */
public interface Expression {
    List<Path> evaluate(Path dir);
}
