package pattern.templatemethod;

import java.util.List;

/**
 * 基底レポートクラス（Template Method パターン）
 *
 * テンプレートメソッド outputReport() が処理の骨格を定義し、
 * サブクラスが各ステップ（フックメソッド）をオーバーライドする。
 */
public abstract class Report {

    protected final String title = "月次報告";
    protected final List<String> text = List.of("順調", "最高の調子");

    /**
     * テンプレートメソッド: レポート出力の骨格
     */
    public String outputReport() {
        StringBuilder sb = new StringBuilder();
        outputStart(sb);
        outputHead(sb);
        outputBodyStart(sb);
        outputBody(sb);
        outputBodyEnd(sb);
        outputEnd(sb);
        return sb.toString();
    }

    protected void outputBody(StringBuilder sb) {
        for (String line : text) {
            outputLine(sb, line);
        }
    }

    // フックメソッド（デフォルトは何もしない）
    protected void outputStart(StringBuilder sb) {}

    protected void outputHead(StringBuilder sb) {
        outputLine(sb, title);
    }

    protected void outputBodyStart(StringBuilder sb) {}

    /**
     * 抽象メソッド: サブクラスでオーバーライド必須
     */
    protected abstract void outputLine(StringBuilder sb, String line);

    protected void outputBodyEnd(StringBuilder sb) {}

    protected void outputEnd(StringBuilder sb) {}
}
