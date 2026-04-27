<?php

declare(strict_types=1);

namespace DesignPattern\Strategy;

class HtmlFormatter
{
    public function __invoke(string $title, array $text): string
    {
        $lines = [
            '<html>',
            ' <head>',
            " <title>{$title}</title>",
            ' </head>',
            '<body>',
        ];
        foreach ($text as $line) {
            $lines[] = " <p>{$line}</p>";
        }
        $lines[] = '</body>';
        $lines[] = '</html>';
        return implode("\n", $lines);
    }
}
