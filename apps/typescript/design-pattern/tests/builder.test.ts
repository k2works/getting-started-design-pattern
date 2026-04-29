import { ComputerBuilder, DesktopBuilder, LaptopBuilder } from '../src/builder';

describe('Builder パターン', () => {
  it('method chaining で Computer を構築できる', () => {
    const computer = new ComputerBuilder()
      .setDisplay('24-inch')
      .setMotherboard('ASUS', 'LGA1700')
      .addDrive('ssd', 512)
      .setMemory(16)
      .build();

    expect(computer.display).toBe('24-inch');
    expect(computer.motherboard.brand).toBe('ASUS');
    expect(computer.drives).toHaveLength(1);
    expect(computer.memoryGb).toBe(16);
  });

  it('Motherboard なしだとエラーになる', () => {
    expect(() =>
      new ComputerBuilder().addDrive('ssd', 256).setMemory(8).build()
    ).toThrow('Motherboard is required');
  });

  it('Drive なしだとエラーになる', () => {
    expect(() =>
      new ComputerBuilder()
        .setMotherboard('MSI', 'AM5')
        .setMemory(8)
        .build()
    ).toThrow('At least one drive is required');
  });

  it('メモリ 0 以下だとエラーになる', () => {
    expect(() =>
      new ComputerBuilder()
        .setMotherboard('MSI', 'AM5')
        .addDrive('ssd', 256)
        .build()
    ).toThrow('Memory must be greater than 0');
  });

  it('DesktopBuilder はデフォルトでデスクトップ設定を持つ', () => {
    const computer = new DesktopBuilder()
      .setMotherboard('ASUS', 'LGA1700')
      .addDrive('hdd', 1000)
      .setMemory(32)
      .build();

    expect(computer.type).toBe('desktop');
    expect(computer.display).toBe('27-inch Monitor');
  });

  it('LaptopBuilder はデフォルトでラップトップ設定を持つ', () => {
    const computer = new LaptopBuilder()
      .setMotherboard('Intel', 'BGA')
      .addDrive('ssd', 512)
      .setMemory(16)
      .build();

    expect(computer.type).toBe('laptop');
    expect(computer.display).toBe('15-inch Retina');
  });

  it('複数のドライブを追加できる', () => {
    const computer = new ComputerBuilder()
      .setMotherboard('ASUS', 'LGA1700')
      .addDrive('ssd', 256)
      .addDrive('hdd', 2000)
      .setMemory(16)
      .build();

    expect(computer.drives).toHaveLength(2);
    expect(computer.drives[0].type).toBe('ssd');
    expect(computer.drives[1].type).toBe('hdd');
  });
});
