# frozen_string_literal: true

# CPU 基底クラス
class CPU
  def to_s
    'CPU'
  end
end

# 基本 CPU
class BasicCPU < CPU
  def to_s
    'BasicCPU'
  end
end

# ターボ CPU
class TurboCPU < CPU
  def to_s
    'TurboCPU'
  end
end

# マザーボード
class Motherboard
  attr_reader :cpu, :memory_size

  def initialize(cpu, memory_size)
    @cpu = cpu
    @memory_size = memory_size
  end
end

# ドライブ
class Drive
  attr_reader :type, :size, :writable

  def initialize(type, size, writable)
    @type = type
    @size = size
    @writable = writable
  end
end

# コンピュータ
class Computer
  attr_reader :display, :motherboard, :drives

  def initialize(display, motherboard, drives)
    @display = display
    @motherboard = motherboard
    @drives = drives
  end
end

# コンピュータビルダー基底クラス
class ComputerBuilder
  attr_reader :computer

  def turbo(has_turbo = true)
    @turbo = has_turbo
  end

  attr_writer :memory_size

  def add_cd(writable = false)
    @drives << Drive.new(:cd, 760, writable)
  end

  def add_dvd(writable = false)
    @drives << Drive.new(:dvd, 4700, writable)
  end

  def add_hard_disk(size)
    @drives << Drive.new(:hard_disk, size, true)
  end

  def computer
    validate!
    cpu = @turbo ? TurboCPU.new : BasicCPU.new
    motherboard = Motherboard.new(cpu, @memory_size)
    Computer.new(@display, motherboard, @drives)
  end

  private

  def validate!
    raise "Not enough memory: #{@memory_size}" if @memory_size < 250
    raise "Too many drives: #{@drives.size}" if @drives.size > 4
    raise 'Must have at least one hard disk' unless @drives.any? { |d| d.type == :hard_disk }
  end
end

# デスクトップビルダー
class DesktopBuilder < ComputerBuilder
  def initialize
    @turbo = false
    @memory_size = 512
    @drives = []
    @display = :crt
  end
end

# ラップトップビルダー
class LaptopBuilder < ComputerBuilder
  def initialize
    @turbo = false
    @memory_size = 512
    @drives = []
    @display = :lcd
  end

  def computer
    raise 'Laptop display must be LCD' unless @display == :lcd

    super
  end
end
