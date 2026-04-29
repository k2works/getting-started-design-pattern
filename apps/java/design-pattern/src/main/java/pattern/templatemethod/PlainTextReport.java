package pattern.templatemethod;

/**
 * プレーンテキスト形式のレポート出力
 */
public class PlainTextReport extends Report {

    @Override
    protected void outputHead(StringBuilder sb) {
        sb.append("**** ").append(title).append(" ****\n");
        sb.append("\n");
    }

    @Override
    protected void outputLine(StringBuilder sb, String line) {
        sb.append(line).append("\n");
    }
}
