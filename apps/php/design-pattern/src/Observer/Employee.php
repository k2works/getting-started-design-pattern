<?php

declare(strict_types=1);

namespace DesignPattern\Observer;

interface Observer
{
    public function update(Employee $employee): void;
}

class Employee
{
    private string $name;
    private string $title;
    private float $salary;
    private \SplObjectStorage $observers;

    public function __construct(string $name, string $title, float $salary)
    {
        $this->name = $name;
        $this->title = $title;
        $this->salary = $salary;
        $this->observers = new \SplObjectStorage();
    }

    public function getName(): string
    {
        return $this->name;
    }

    public function getTitle(): string
    {
        return $this->title;
    }

    public function getSalary(): float
    {
        return $this->salary;
    }

    public function setSalary(float $salary): void
    {
        $this->salary = $salary;
        $this->notifyObservers();
    }

    public function setTitle(string $title): void
    {
        $this->title = $title;
        $this->notifyObservers();
    }

    public function addObserver(Observer $observer): void
    {
        $this->observers->offsetSet($observer);
    }

    public function removeObserver(Observer $observer): void
    {
        $this->observers->offsetUnset($observer);
    }

    private function notifyObservers(): void
    {
        foreach ($this->observers as $observer) {
            $observer->update($this);
        }
    }
}
