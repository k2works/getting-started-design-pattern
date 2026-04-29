<?php

declare(strict_types=1);

namespace DesignPattern\Strategy;

class PlainTextFormatter
{
    public function __invoke(string $title, array $text): string
    {
        $lines = ["**** {$title} ****", ''];
        foreach ($text as $line) {
            $lines[] = $line;
        }
        return implode("\n", $lines);
    }
}
