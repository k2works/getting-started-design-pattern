import { describe, it, expect } from '@jest/globals';
import {
  ComputerBuilder,
  DesktopBuilder,
  LaptopBuilder,
  Drive,
  Motherboard,
} from '../src/builder.js';

describe('Builder パターン', () => {
  it('ComputerBuilder でメソッドチェーンを使って構築できる', () => {
    const computer = new ComputerBuilder()
      .setDisplay('24-inch')
      .setMotherboard('Z790')
      .setMemory(16)
      .addDrive('ssd', 512)
      .build();

    expect(computer.display).toBe('24-inch');
    expect(computer.motherboard.model).toBe('Z790');
    expect(computer.memory).toBe(16);
    expect(computer.drives).toHaveLength(1);
  });

  it('マザーボードなしで build すると例外が発生する', () => {
    expect(() => {
      new ComputerBuilder().setMemory(16).build();
    }).toThrow('マザーボードは必須です');
  });

  it('メモリなしで build すると例外が発生する', () => {
    expect(() => {
      new ComputerBuilder().setMotherboard('Z790').build();
    }).toThrow('メモリは必須です');
  });

  it('DesktopBuilder がデスクトップ構成を構築する', () => {
    const computer = new DesktopBuilder().build();

    expect(computer.display).toBe('27-inch 4K');
    expect(computer.motherboard.model).toBe('ATX-Z790');
    expect(computer.memory).toBe(32);
    expect(computer.drives).toHaveLength(2);
    expect(computer.drives[0].type).toBe('ssd');
    expect(computer.drives[1].type).toBe('hdd');
  });

  it('LaptopBuilder がラップトップ構成を構築する', () => {
    const computer = new LaptopBuilder().build();

    expect(computer.display).toBe('15-inch Retina');
    expect(computer.motherboard.model).toBe('Mobile-M2');
    expect(computer.memory).toBe(16);
    expect(computer.drives).toHaveLength(1);
  });

  it('Drive の toString が型とサイズを返す', () => {
    const drive = new Drive('ssd', 1000);
    expect(drive.toString()).toBe('SSD 1000GB');
  });

  it('Computer の toString が全構成を返す', () => {
    const computer = new DesktopBuilder().build();
    const str = computer.toString();

    expect(str).toContain('Display: 27-inch 4K');
    expect(str).toContain('Motherboard: ATX-Z790');
    expect(str).toContain('Memory: 32GB');
  });
});
