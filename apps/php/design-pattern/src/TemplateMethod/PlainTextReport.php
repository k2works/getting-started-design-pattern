<?php

declare(strict_types=1);

namespace DesignPattern\TemplateMethod;

class PlainTextReport extends Report
{
    protected function outputHead(): array
    {
        return ["**** {$this->title} ****", ''];
    }

    protected function outputLine(string $line): array
    {
        return [$line];
    }
}
