package pattern.templatemethod;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class TemplateMethodTest {

    @Test
    void htmlReportOutputsValidHtml() {
        Report report = new HtmlReport();
        String output = report.outputReport();

        assertTrue(output.startsWith("<html>"));
        assertTrue(output.endsWith("</html>\n"));
        assertTrue(output.contains("<title>月次報告</title>"));
        assertTrue(output.contains("<p>順調</p>"));
        assertTrue(output.contains("<p>最高の調子</p>"));
    }

    @Test
    void plainTextReportOutputsFormattedText() {
        Report report = new PlainTextReport();
        String output = report.outputReport();

        assertTrue(output.startsWith("**** 月次報告 ****"));
        assertTrue(output.contains("順調"));
        assertTrue(output.contains("最高の調子"));
        assertFalse(output.contains("<html>"));
    }

    @Test
    void htmlReportContainsBodyTags() {
        Report report = new HtmlReport();
        String output = report.outputReport();

        assertTrue(output.contains("<body>"));
        assertTrue(output.contains("</body>"));
    }

    @Test
    void plainTextReportDoesNotContainHtmlTags() {
        Report report = new PlainTextReport();
        String output = report.outputReport();

        assertFalse(output.contains("<html>"));
        assertFalse(output.contains("<body>"));
        assertFalse(output.contains("<p>"));
    }
}
