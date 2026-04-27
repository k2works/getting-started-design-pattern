<?php

declare(strict_types=1);

namespace DesignPattern\TemplateMethod;

class HtmlReport extends Report
{
    protected function outputStart(): array
    {
        return ['<html>'];
    }

    protected function outputHead(): array
    {
        return [' <head>', " <title>{$this->title}</title>", ' </head>'];
    }

    protected function outputBodyStart(): array
    {
        return ['<body>'];
    }

    protected function outputLine(string $line): array
    {
        return [" <p>{$line}</p>"];
    }

    protected function outputBodyEnd(): array
    {
        return ['</body>'];
    }

    protected function outputEnd(): array
    {
        return ['</html>'];
    }
}
