package pattern.observer;

/**
 * 税務担当オブザーバー
 */
public class TaxMan implements Observer {

    private String lastNotification;

    @Override
    public void update(Employee employee) {
        lastNotification = employee.getName() + " に新しい税金の請求書を送付します";
    }

    public String getLastNotification() {
        return lastNotification;
    }
}
