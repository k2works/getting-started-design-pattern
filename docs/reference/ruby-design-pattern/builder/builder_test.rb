require 'minitest/autorun'
require './cpu'
require './basic_cpu'
require './turbo_cpu'
require './motherboard'
require './drive'
require './laptop_drive'
require './computer'
require './desktop_computer'
require './laptop_computer'
require './computer_builder'
require './desktop_builder'
require './laptop_builder'

describe Computer do
  describe 'when not using builder.' do
    before(:each) do
      motherboard = Motherboard.new(TurboCPU.new, 4000)

      drives = []
      drives << Drive.new(:hard_drive, 200000, true)
      drives << Drive.new(:cd, 760, true)
      drives << Drive.new(:dvd, 4700, false)

      @computer = Computer.new(:lcd, motherboard, drives)
    end

    # LCDディスプレイを搭載している
    it 'should have LCD display.' do
      @computer.display.must_equal :lcd
    end

    # TurboCPUを搭載している
    it 'should have TurboCPU on motherboard.' do
      @computer.motherboard.cpu.must_be_instance_of TurboCPU
    end

    # 200GBの書き込み可能ハードディスクドライブを搭載している
    it 'should have 200GB writable hard drive.' do
      @computer.drives[0].type.must_equal :hard_drive
      @computer.drives[0].size.must_equal 200000
      @computer.drives[0].writable.must_equal true
    end

    # 760MBの書き込み可能CDドライブを搭載している
    it 'should have 760MB writable cd drive.' do
      @computer.drives[1].type.must_equal :cd
      @computer.drives[1].size.must_equal 760
      @computer.drives[1].writable.must_equal true
    end

    # 4.7GBの読み込み専用DVDドライブを搭載している
    it 'should have 4.7GB read only dvd drive.' do
      @computer.drives[2].type.must_equal :dvd
      @computer.drives[2].size.must_equal 4700
      @computer.drives[2].writable.must_equal false
    end
  end
end

describe ComputerBuilder do

  describe 'when using desktop builder.' do
    before(:each) do
      @builder = DesktopBuilder.new
      @builder.turbo
      @builder.add_cd(true)
      @builder.add_dvd
      @builder.add_hard_disk(100000)
    end

    # CRTディスプレイを搭載している
    it 'should have CRT display.' do
      computer = @builder.computer
      computer.display.must_equal :crt
    end

    # TurboCPUを搭載している
    it 'should have TurboCPU on motherboard.' do
      computer = @builder.computer
      computer.motherboard.cpu.must_be_instance_of TurboCPU
    end

    # 760MBの書き込み可能CDドライブを搭載している
    it 'should have 760MB writable cd drive.' do
      computer = @builder.computer
      computer.drives[0].type.must_equal :cd
      computer.drives[0].size.must_equal 760
      computer.drives[0].writable.must_equal true
    end

    # 4GBの読み込み専用DVDドライブを搭載している
    it 'should have 4GB read only dvd drive.' do
      computer = @builder.computer
      computer.drives[1].type.must_equal :dvd
      computer.drives[1].size.must_equal 4000
      computer.drives[1].writable.must_equal false
    end

    # 100GBの書き込み可能ハードディスクドライブを搭載している
    it 'should have 100GB writable hard drive.' do
      computer = @builder.computer
      computer.drives[2].type.must_equal :hard_disk
      computer.drives[2].size.must_equal 100000
      computer.drives[2].writable.must_equal true
    end

    # フル構成でセットアップする
    it 'should build full components.' do
      builder = DesktopBuilder.new
      builder.add_turbo_and_cd_and_dvd_and_harddisk
      computer = builder.computer

      computer.motherboard.cpu.must_be_instance_of TurboCPU
      computer.drives[0].type.must_equal :cd
      computer.drives[0].size.must_equal 760
      computer.drives[0].writable.must_equal false
      computer.drives[1].type.must_equal :dvd
      computer.drives[1].size.must_equal 4000
      computer.drives[1].writable.must_equal false
      computer.drives[2].type.must_equal :hard_disk
      computer.drives[2].size.must_equal 100000
      computer.drives[2].writable.must_equal true
    end

    describe 'when incomplete constitution.' do
      before(:each) do
        @builder = DesktopBuilder.new
      end

      # メモリサイズが足りなければ例外を出す
      it 'should raise exception when not enough memory.' do
        @builder.add_hard_disk(1000)
        @builder.memory_size = 249
        proc {@builder.computer}.must_raise RuntimeError
      end

      # ドライブ数が多過げれば例外を出す
      it 'should raise exception when too many drives.' do
        5.times {@builder.add_hard_disk(1000)}
        proc {@builder.computer}.must_raise RuntimeError
      end

      # ドライブ数が０ならば例外を出す
      it 'should raise exception when no drives.' do
        0.times {@builder.add_hard_disk(1000)}
        proc {@builder.computer}.must_raise RuntimeError
      end
    end

    describe 'when reuse builder.' do
      before(:each) do
        @builder = DesktopBuilder.new
        @builder.add_hard_disk(10000)
        @builder.turbo
      end
      # ２つの同じ構成のコンピュータを別インスタンスで作成する
      it 'should build same computer but other instance.' do
        computer1 = @builder.computer

        @builder.reset
        @builder = DesktopBuilder.new
        @builder.add_hard_disk(10000)
        @builder.turbo
        computer2 = @builder.computer

        computer1.wont_be_same_as computer2
      end
    end
  end

  describe 'when using laptop builder.' do
    before(:each) do
      @builder = LaptopBuilder.new
      @builder.turbo
      @builder.add_cd(true)
      @builder.add_dvd
      @builder.add_hard_disk(100000)
    end

    # LCDディスプレイを搭載している
    it 'should have LCD display.' do
      computer = @builder.computer
      computer.display.must_equal :lcd
    end

    # TurboCPUを搭載している
    it 'should have TurboCPU on motherboard.' do
      computer = @builder.computer
      computer.motherboard.cpu.must_be_instance_of TurboCPU
    end

    # 760MBの書き込み可能CDドライブを搭載している
    it 'should have 760MB writable cd drive.' do
      computer = @builder.computer
      computer.drives[0].type.must_equal :cd
      computer.drives[0].size.must_equal 760
      computer.drives[0].writable.must_equal true
    end

    # 4GBの読み込み専用DVDドライブを搭載している
    it 'should have 4GB read only dvd drive.' do
      computer = @builder.computer
      computer.drives[1].type.must_equal :dvd
      computer.drives[1].size.must_equal 4000
      computer.drives[1].writable.must_equal false
    end

    # 100GBの書き込み可能ハードディスクドライブを搭載している
    it 'should have 100GB writable hard drive.' do
      computer = @builder.computer
      computer.drives[2].type.must_equal :hard_disk
      computer.drives[2].size.must_equal 100000
      computer.drives[2].writable.must_equal true
    end

    # フル構成でセットアップする
    it 'should build full components.' do
      builder = LaptopBuilder.new
      builder.add_turbo_and_cd_and_dvd_and_harddisk
      computer = builder.computer

      computer.motherboard.cpu.must_be_instance_of TurboCPU
      computer.drives[0].type.must_equal :cd
      computer.drives[0].size.must_equal 760
      computer.drives[0].writable.must_equal false
      computer.drives[1].type.must_equal :dvd
      computer.drives[1].size.must_equal 4000
      computer.drives[1].writable.must_equal false
      computer.drives[2].type.must_equal :hard_disk
      computer.drives[2].size.must_equal 100000
      computer.drives[2].writable.must_equal true
    end

    describe 'when incomplete constitution.' do
      before(:each) do
        @builder = LaptopBuilder.new
      end

      # メモリサイズが足りなければ例外を出す
      it 'should raise exception when not enough memory.' do
        @builder.add_hard_disk(1000)
        @builder.memory_size = 249
        proc {@builder.computer}.must_raise RuntimeError
      end

      # ドライブ数が多過げれば例外を出す
      it 'should raise exception when too many drives.' do
        5.times {@builder.add_hard_disk(1000)}
        proc {@builder.computer}.must_raise RuntimeError
      end

      # ドライブ数が０ならば例外を出す
      it 'should raise exception when no drives.' do
        0.times {@builder.add_hard_disk(1000)}
        proc {@builder.computer}.must_raise RuntimeError
      end
    end

    describe 'when reuse builder.' do
      before(:each) do
        @builder = LaptopBuilder.new
        @builder.add_hard_disk(10000)
        @builder.turbo
      end
      # ２つの同じ構成のコンピュータを別インスタンスで作成する
      it 'should build same computer but other instance.' do
        computer1 = @builder.computer

        @builder.reset
        @builder = LaptopBuilder.new
        @builder.add_hard_disk(10000)
        @builder.turbo
        computer2 = @builder.computer

        computer1.wont_be_same_as computer2
      end
    end
  end

end