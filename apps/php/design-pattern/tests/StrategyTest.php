<?php

declare(strict_types=1);

namespace DesignPattern\Tests;

use DesignPattern\Strategy\HtmlFormatter;
use DesignPattern\Strategy\PlainTextFormatter;
use DesignPattern\Strategy\Report;
use PHPUnit\Framework\TestCase;

class StrategyTest extends TestCase
{
    public function testHtmlFormatterOutput(): void
    {
        $report = new Report(new HtmlFormatter());
        $output = $report->outputReport();

        $this->assertStringContainsString('<html>', $output);
        $this->assertStringContainsString('<title>月次報告</title>', $output);
        $this->assertStringContainsString('<p>順調</p>', $output);
    }

    public function testPlainTextFormatterOutput(): void
    {
        $report = new Report(new PlainTextFormatter());
        $output = $report->outputReport();

        $this->assertStringContainsString('**** 月次報告 ****', $output);
        $this->assertStringContainsString('順調', $output);
    }

    public function testSwitchFormatterAtRuntime(): void
    {
        $report = new Report(new HtmlFormatter());
        $this->assertStringContainsString('<html>', $report->outputReport());

        $report->setFormatter(new PlainTextFormatter());
        $this->assertStringContainsString('****', $report->outputReport());
    }

    public function testLambdaAsStrategy(): void
    {
        $upper = fn(string $title, array $text): string =>
            strtoupper($title) . "\n" . implode("\n", array_map('strtoupper', $text));

        $report = new Report($upper, 'Test', ['hello']);
        $output = $report->outputReport();

        $this->assertSame("TEST\nHELLO", $output);
    }

    public function testCustomTitleAndText(): void
    {
        $report = new Report(new PlainTextFormatter(), '日次報告', ['問題なし']);
        $output = $report->outputReport();

        $this->assertStringContainsString('**** 日次報告 ****', $output);
        $this->assertStringContainsString('問題なし', $output);
    }
}
