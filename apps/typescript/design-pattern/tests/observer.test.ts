import { Employee, Payroll, TaxMan } from '../src/observer';

describe('Observer パターン', () => {
  it('給与変更時に Payroll に通知される', () => {
    const employee = new Employee('Alice', 'Engineer', 50000);
    const payroll = new Payroll();
    employee.addObserver(payroll);

    employee.setSalary(60000);

    expect(payroll.getLastChange()).toBe(
      'Payroll: Cut check for Alice at 60000'
    );
  });

  it('タイトル変更時に TaxMan に通知される', () => {
    const employee = new Employee('Bob', 'Engineer', 50000);
    const taxMan = new TaxMan();
    employee.addObserver(taxMan);

    employee.setTitle('Senior Engineer');

    expect(taxMan.getLastChange()).toContain('TaxMan');
    expect(taxMan.getLastChange()).toContain('Bob');
  });

  it('複数のオブザーバーに同時に通知される', () => {
    const employee = new Employee('Carol', 'Manager', 70000);
    const payroll = new Payroll();
    const taxMan = new TaxMan();
    employee.addObserver(payroll);
    employee.addObserver(taxMan);

    employee.setSalary(80000);

    expect(payroll.getLastChange()).toContain('80000');
    expect(taxMan.getLastChange()).toContain('80000');
  });

  it('オブザーバーを削除すると通知されなくなる', () => {
    const employee = new Employee('Dave', 'Director', 90000);
    const payroll = new Payroll();
    employee.addObserver(payroll);

    employee.setSalary(95000);
    expect(payroll.getLastChange()).toContain('95000');

    employee.removeObserver(payroll);
    employee.setSalary(100000);

    // payroll still has the old change
    expect(payroll.getLastChange()).toContain('95000');
  });

  it('従業員の名前・タイトル・給与を取得できる', () => {
    const employee = new Employee('Eve', 'CTO', 150000);
    expect(employee.getName()).toBe('Eve');
    expect(employee.getTitle()).toBe('CTO');
    expect(employee.getSalary()).toBe(150000);
  });
});
