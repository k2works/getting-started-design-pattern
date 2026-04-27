package pattern.observer;

/**
 * 給与計算オブザーバー
 */
public class Payroll implements Observer {

    private String lastNotification;

    @Override
    public void update(Employee employee) {
        lastNotification = employee.getName() + " の給与が " + employee.getSalary() + " に変更されました";
    }

    public String getLastNotification() {
        return lastNotification;
    }
}
