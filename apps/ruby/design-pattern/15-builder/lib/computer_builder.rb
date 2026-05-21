require_relative "parts"

class ComputerBuilder
  def initialize(display:)
    @display = display
    @turbo = false
    @memory_size = 512
    @drives = []
  end

  def turbo(has_turbo = true)
    @turbo = has_turbo
  end

  def memory_size=(size)
    @memory_size = size
  end

  def add_cd(writable = false)
    @drives << Drive.new(:cd, 760, writable)
  end

  def add_dvd(writable = false)
    @drives << Drive.new(:dvd, 4_700, writable)
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
    raise "Must have at least one hard disk" unless @drives.any? { |drive| drive.type == :hard_disk }
  end
end

class DesktopBuilder < ComputerBuilder
  def initialize
    super(display: :crt)
  end
end

class LaptopBuilder < ComputerBuilder
  def initialize
    super(display: :lcd)
  end

  def computer
    raise "Laptop display must be LCD" unless @display == :lcd
    super
  end
end
