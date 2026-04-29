<?php

declare(strict_types=1);

namespace DesignPattern\Tests;

use DesignPattern\TemplateMethod\HtmlReport;
use DesignPattern\TemplateMethod\PlainTextReport;
use PHPUnit\Framework\TestCase;

class TemplateMethodTest extends TestCase
{
    public function testHtmlReportContainsHtmlTags(): void
    {
        $report = new HtmlReport();
        $output = $report->outputReport();

        $this->assertStringContainsString('<html>', $output);
        $this->assertStringContainsString('</html>', $output);
    }

    public function testHtmlReportContainsTitle(): void
    {
        $report = new HtmlReport();
        $output = $report->outputReport();

        $this->assertStringContainsString('<title>月次報告</title>', $output);
    }

    public function testHtmlReportContainsBodyContent(): void
    {
        $report = new HtmlReport();
        $output = $report->outputReport();

        $this->assertStringContainsString('<p>順調</p>', $output);
        $this->assertStringContainsString('<p>最高の調子</p>', $output);
    }

    public function testPlainTextReportContainsTitle(): void
    {
        $report = new PlainTextReport();
        $output = $report->outputReport();

        $this->assertStringContainsString('**** 月次報告 ****', $output);
    }

    public function testPlainTextReportContainsBodyContent(): void
    {
        $report = new PlainTextReport();
        $output = $report->outputReport();

        $this->assertStringContainsString('順調', $output);
        $this->assertStringContainsString('最高の調子', $output);
    }

    public function testCustomTitleAndText(): void
    {
        $report = new HtmlReport('週次報告', ['良好']);
        $output = $report->outputReport();

        $this->assertStringContainsString('<title>週次報告</title>', $output);
        $this->assertStringContainsString('<p>良好</p>', $output);
    }
}
