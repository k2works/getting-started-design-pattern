package pattern.strategy;

import java.util.List;

/**
 * フォーマッター戦略インターフェース（Strategy パターン）
 *
 * FunctionalInterface により、ラムダ式でも実装可能。
 */
@FunctionalInterface
public interface Formatter {

    String format(String title, List<String> text);
}
