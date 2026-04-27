<?php

declare(strict_types=1);

namespace DesignPattern\TemplateMethod;

abstract class Report
{
    protected string $title;
    protected array $text;

    public function __construct(string $title = '月次報告', array $text = ['順調', '最高の調子'])
    {
        $this->title = $title;
        $this->text = $text;
    }

    /** テンプレートメソッド: レポート出力の骨格 */
    public function outputReport(): string
    {
        $lines = [];
        $lines = array_merge($lines, $this->outputStart());
        $lines = array_merge($lines, $this->outputHead());
        $lines = array_merge($lines, $this->outputBodyStart());
        $lines = array_merge($lines, $this->outputBody());
        $lines = array_merge($lines, $this->outputBodyEnd());
        $lines = array_merge($lines, $this->outputEnd());
        return implode("\n", $lines);
    }

    protected function outputBody(): array
    {
        $lines = [];
        foreach ($this->text as $line) {
            $lines = array_merge($lines, $this->outputLine($line));
        }
        return $lines;
    }

    /** フックメソッド（デフォルトは何もしない） */
    protected function outputStart(): array
    {
        return [];
    }

    protected function outputHead(): array
    {
        return $this->outputLine($this->title);
    }

    protected function outputBodyStart(): array
    {
        return [];
    }

    /** 抽象メソッド */
    abstract protected function outputLine(string $line): array;

    protected function outputBodyEnd(): array
    {
        return [];
    }

    protected function outputEnd(): array
    {
        return [];
    }
}
