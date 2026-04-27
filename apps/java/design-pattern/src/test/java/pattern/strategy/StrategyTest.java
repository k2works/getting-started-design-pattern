package pattern.strategy;

import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

class StrategyTest {

    @Test
    void htmlFormatterOutputsHtml() {
        Formatter formatter = new HtmlFormatter();
        Report report = new Report(formatter);
        String output = report.outputReport();

        assertTrue(output.contains("<html>"));
        assertTrue(output.contains("<title>月次報告</title>"));
        assertTrue(output.contains("<p>順調</p>"));
        assertTrue(output.contains("<p>最高の調子</p>"));
        assertTrue(output.contains("</html>"));
    }

    @Test
    void plainTextFormatterOutputsText() {
        Formatter formatter = new PlainTextFormatter();
        Report report = new Report(formatter);
        String output = report.outputReport();

        assertTrue(output.contains("**** 月次報告 ****"));
        assertTrue(output.contains("順調"));
        assertTrue(output.contains("最高の調子"));
        assertFalse(output.contains("<html>"));
    }

    @Test
    void canSwapFormatterAtRuntime() {
        Report report = new Report(new HtmlFormatter());
        String htmlOutput = report.outputReport();
        assertTrue(htmlOutput.contains("<html>"));

        report.setFormatter(new PlainTextFormatter());
        String textOutput = report.outputReport();
        assertTrue(textOutput.contains("****"));
        assertFalse(textOutput.contains("<html>"));
    }

    @Test
    void supportsLambdaAsFormatter() {
        Formatter lambdaFormatter = (title, text) -> {
            StringBuilder sb = new StringBuilder();
            sb.append("== ").append(title).append(" ==\n");
            for (String line : text) {
                sb.append("- ").append(line).append("\n");
            }
            return sb.toString();
        };

        Report report = new Report(lambdaFormatter);
        String output = report.outputReport();

        assertTrue(output.contains("== 月次報告 =="));
        assertTrue(output.contains("- 順調"));
        assertTrue(output.contains("- 最高の調子"));
    }
}
