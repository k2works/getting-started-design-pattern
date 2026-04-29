<?php

declare(strict_types=1);

namespace DesignPattern\Interpreter;

abstract class Expression
{
    abstract public function evaluate(string $dir): array;
}

class All extends Expression
{
    public function evaluate(string $dir): array
    {
        if (!is_dir($dir)) {
            return [];
        }
        $files = [];
        $entries = scandir($dir);
        foreach ($entries as $entry) {
            if ($entry === '.' || $entry === '..') {
                continue;
            }
            $path = $dir . DIRECTORY_SEPARATOR . $entry;
            if (is_file($path)) {
                $files[] = $path;
            }
        }
        return $files;
    }
}

class FileName extends Expression
{
    private string $pattern;

    public function __construct(string $pattern)
    {
        $this->pattern = $pattern;
    }

    public function evaluate(string $dir): array
    {
        $all = (new All())->evaluate($dir);
        return array_values(
            array_filter($all, fn(string $path) => fnmatch($this->pattern, basename($path)))
        );
    }
}

class Bigger extends Expression
{
    private int $sizeBytes;

    public function __construct(int $sizeBytes)
    {
        $this->sizeBytes = $sizeBytes;
    }

    public function evaluate(string $dir): array
    {
        $all = (new All())->evaluate($dir);
        return array_values(
            array_filter($all, fn(string $path) => filesize($path) > $this->sizeBytes)
        );
    }
}

class AndExpression extends Expression
{
    private Expression $left;
    private Expression $right;

    public function __construct(Expression $left, Expression $right)
    {
        $this->left = $left;
        $this->right = $right;
    }

    public function evaluate(string $dir): array
    {
        $leftResult = $this->left->evaluate($dir);
        $rightResult = $this->right->evaluate($dir);
        return array_values(array_intersect($leftResult, $rightResult));
    }
}

class OrExpression extends Expression
{
    private Expression $left;
    private Expression $right;

    public function __construct(Expression $left, Expression $right)
    {
        $this->left = $left;
        $this->right = $right;
    }

    public function evaluate(string $dir): array
    {
        $leftResult = $this->left->evaluate($dir);
        $rightResult = $this->right->evaluate($dir);
        return array_values(array_unique(array_merge($leftResult, $rightResult)));
    }
}

class NotExpression extends Expression
{
    private Expression $expression;

    public function __construct(Expression $expression)
    {
        $this->expression = $expression;
    }

    public function evaluate(string $dir): array
    {
        $all = (new All())->evaluate($dir);
        $excluded = $this->expression->evaluate($dir);
        return array_values(array_diff($all, $excluded));
    }
}
