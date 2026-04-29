package pattern.observer;

import java.util.ArrayList;
import java.util.List;

/**
 * 従業員クラス（Observer パターン - Subject）
 *
 * オブザーバーのリストを保持し、給与やタイトルの変更を通知する。
 */
public class Employee {

    private final String name;
    private String title;
    private int salary;
    private final List<Observer> observers = new ArrayList<>();

    public Employee(String name, String title, int salary) {
        this.name = name;
        this.title = title;
        this.salary = salary;
    }

    public void addObserver(Observer observer) {
        observers.add(observer);
    }

    public void removeObserver(Observer observer) {
        observers.remove(observer);
    }

    public void setSalary(int newSalary) {
        this.salary = newSalary;
        notifyObservers();
    }

    public void setTitle(String newTitle) {
        this.title = newTitle;
        notifyObservers();
    }

    private void notifyObservers() {
        for (Observer observer : observers) {
            observer.update(this);
        }
    }

    public String getName() {
        return name;
    }

    public String getTitle() {
        return title;
    }

    public int getSalary() {
        return salary;
    }
}
