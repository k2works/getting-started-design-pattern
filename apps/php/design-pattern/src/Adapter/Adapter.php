<?php

declare(strict_types=1);

namespace DesignPattern\Adapter;

interface TextObject
{
    public function getText(): string;

    public function getSizeInches(): float;

    public function getColor(): string;
}

class BritishTextObject
{
    private string $text;
    private float $sizeMm;
    private string $colour;

    public function __construct(string $text, float $sizeMm, string $colour)
    {
        $this->text = $text;
        $this->sizeMm = $sizeMm;
        $this->colour = $colour;
    }

    public function getString(): string
    {
        return $this->text;
    }

    public function getSizeMm(): float
    {
        return $this->sizeMm;
    }

    public function getColour(): string
    {
        return $this->colour;
    }
}

class BritishTextObjectAdapter implements TextObject
{
    private BritishTextObject $adaptee;

    public function __construct(BritishTextObject $adaptee)
    {
        $this->adaptee = $adaptee;
    }

    public function getText(): string
    {
        return $this->adaptee->getString();
    }

    public function getSizeInches(): float
    {
        return $this->adaptee->getSizeMm() / 25.4;
    }

    public function getColor(): string
    {
        return $this->adaptee->getColour();
    }
}

class Renderer
{
    public function render(TextObject $textObject): string
    {
        return sprintf(
            '%s (%.1f inches, %s)',
            $textObject->getText(),
            $textObject->getSizeInches(),
            $textObject->getColor()
        );
    }
}
