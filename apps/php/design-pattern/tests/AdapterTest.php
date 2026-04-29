<?php

declare(strict_types=1);

namespace DesignPattern\Tests;

use DesignPattern\Adapter\BritishTextObject;
use DesignPattern\Adapter\BritishTextObjectAdapter;
use DesignPattern\Adapter\Renderer;
use PHPUnit\Framework\TestCase;

class AdapterTest extends TestCase
{
    public function testAdapterGetText(): void
    {
        $british = new BritishTextObject('Hello', 25.4, 'red');
        $adapter = new BritishTextObjectAdapter($british);

        $this->assertSame('Hello', $adapter->getText());
    }

    public function testAdapterConvertsMmToInches(): void
    {
        $british = new BritishTextObject('Hello', 25.4, 'red');
        $adapter = new BritishTextObjectAdapter($british);

        $this->assertEqualsWithDelta(1.0, $adapter->getSizeInches(), 0.001);
    }

    public function testAdapterGetColor(): void
    {
        $british = new BritishTextObject('Hello', 25.4, 'blue');
        $adapter = new BritishTextObjectAdapter($british);

        $this->assertSame('blue', $adapter->getColor());
    }

    public function testRendererWithAdapter(): void
    {
        $british = new BritishTextObject('Test', 50.8, 'green');
        $adapter = new BritishTextObjectAdapter($british);
        $renderer = new Renderer();

        $result = $renderer->render($adapter);

        $this->assertStringContainsString('Test', $result);
        $this->assertStringContainsString('2.0 inches', $result);
        $this->assertStringContainsString('green', $result);
    }

    public function testBritishTextObjectDirectAccess(): void
    {
        $british = new BritishTextObject('Direct', 10.0, 'yellow');

        $this->assertSame('Direct', $british->getString());
        $this->assertSame(10.0, $british->getSizeMm());
        $this->assertSame('yellow', $british->getColour());
    }
}
