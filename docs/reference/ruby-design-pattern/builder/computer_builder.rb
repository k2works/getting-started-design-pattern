#
# == コンピュータビルダークラス
#
# Author:: k2works
# Version:: 1.0.0
# License:: Ruby License
#
class ComputerBuilder
  attr_accessor :computer

  def initialize
    @computer = Computer.new
  end

  def turbo(has_turbo_cpu=true)
    @computer.motherboard.cpu = TurboCPU.new
  end

  def memory_size=(size_in_mb)
    @computer.motherboard.memory_size = size_in_mb
  end

  def computer
    raise "Not enough memory" if @computer.motherboard.memory_size < 250
    raise "Too many drives" if @computer.drives.size > 4
    hard_disk = @computer.drives.find {|drive| drive.type == :hard_disk}
    raise "No disk." unless hard_disk
    @computer
  end
end