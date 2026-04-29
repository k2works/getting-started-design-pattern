package pattern.strategy;

import java.util.List;

/**
 * プレーンテキスト形式のフォーマッター
 */
public class PlainTextFormatter implements Formatter {

    @Override
    public String format(String title, List<String> text) {
        StringBuilder sb = new StringBuilder();
        sb.append("**** ").append(title).append(" ****\n");
        sb.append("\n");
        for (String line : text) {
            sb.append(line).append("\n");
        }
        return sb.toString();
    }
}
