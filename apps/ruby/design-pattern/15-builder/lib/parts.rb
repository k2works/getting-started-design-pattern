class CPU
end

class BasicCPU < CPU
end

class TurboCPU < CPU
end

class Motherboard
  attr_reader :cpu, :memory_size

  def initialize(cpu, memory_size)
    @cpu = cpu
    @memory_size = memory_size
  end
end

class Drive
  attr_reader :type, :size, :writable

  def initialize(type, size, writable)
    @type = type
    @size = size
    @writable = writable
  end
end

class Computer
  attr_reader :display, :motherboard, :drives

  def initialize(display, motherboard, drives)
    @display = display
    @motherboard = motherboard
    @drives = drives
  end
end
