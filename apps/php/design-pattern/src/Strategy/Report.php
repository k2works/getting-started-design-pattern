<?php

declare(strict_types=1);

namespace DesignPattern\Strategy;

class Report
{
    private string $title;
    private array $text;
    /** @var callable(string, array): string */
    private $formatter;

    public function __construct(
        callable $formatter,
        string $title = '月次報告',
        array $text = ['順調', '最高の調子']
    ) {
        $this->formatter = $formatter;
        $this->title = $title;
        $this->text = $text;
    }

    public function outputReport(): string
    {
        return ($this->formatter)($this->title, $this->text);
    }

    public function setFormatter(callable $formatter): void
    {
        $this->formatter = $formatter;
    }
}
