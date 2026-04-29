package pattern.strategy;

import java.util.List;

/**
 * レポートクラス（Strategy パターン）
 *
 * Formatter 戦略を受け取り、出力処理を委譲する。
 */
public class Report {

    private final String title = "月次報告";
    private final List<String> text = List.of("順調", "最高の調子");
    private Formatter formatter;

    public Report(Formatter formatter) {
        this.formatter = formatter;
    }

    public String outputReport() {
        return formatter.format(title, text);
    }

    public void setFormatter(Formatter formatter) {
        this.formatter = formatter;
    }

    public String getTitle() {
        return title;
    }

    public List<String> getText() {
        return text;
    }
}
