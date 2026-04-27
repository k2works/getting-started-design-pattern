package pattern.templatemethod;

/**
 * HTML 形式のレポート出力
 */
public class HtmlReport extends Report {

    @Override
    protected void outputStart(StringBuilder sb) {
        sb.append("<html>\n");
    }

    @Override
    protected void outputHead(StringBuilder sb) {
        sb.append(" <head>\n");
        sb.append(" <title>").append(title).append("</title>\n");
        sb.append(" </head>\n");
    }

    @Override
    protected void outputBodyStart(StringBuilder sb) {
        sb.append("<body>\n");
    }

    @Override
    protected void outputLine(StringBuilder sb, String line) {
        sb.append(" <p>").append(line).append("</p>\n");
    }

    @Override
    protected void outputBodyEnd(StringBuilder sb) {
        sb.append("</body>\n");
    }

    @Override
    protected void outputEnd(StringBuilder sb) {
        sb.append("</html>\n");
    }
}
