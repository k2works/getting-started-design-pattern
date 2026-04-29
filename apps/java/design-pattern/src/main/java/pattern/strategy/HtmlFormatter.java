package pattern.strategy;

import java.util.List;

/**
 * HTML 形式のフォーマッター
 */
public class HtmlFormatter implements Formatter {

    @Override
    public String format(String title, List<String> text) {
        StringBuilder sb = new StringBuilder();
        sb.append("<html>\n");
        sb.append(" <head>\n");
        sb.append(" <title>").append(title).append("</title>\n");
        sb.append(" </head>\n");
        sb.append("<body>\n");
        for (String line : text) {
            sb.append(" <p>").append(line).append("</p>\n");
        }
        sb.append("</body>\n");
        sb.append("</html>\n");
        return sb.toString();
    }
}
