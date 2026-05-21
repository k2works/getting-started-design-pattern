require_relative "test_helper"

class DesktopBuilderTest < Minitest::Test
  def test_build_desktop_with_turbo_cd_dvd_hard_disk
    builder = DesktopBuilder.new
    builder.turbo
    builder.memory_size = 1024
    builder.add_cd
    builder.add_dvd(true)
    builder.add_hard_disk(500_000)

    computer = builder.computer

    assert_equal :crt, computer.display
    assert_instance_of TurboCPU, computer.motherboard.cpu
    assert_equal 1024, computer.motherboard.memory_size
    assert_equal 3, computer.drives.size
  end

  def test_build_basic_desktop
    builder = DesktopBuilder.new
    builder.add_hard_disk(250_000)

    computer = builder.computer

    assert_instance_of BasicCPU, computer.motherboard.cpu
    assert_equal 512, computer.motherboard.memory_size
  end
end

class BuilderValidationTest < Minitest::Test
  def test_not_enough_memory
    builder = DesktopBuilder.new
    builder.memory_size = 100
    builder.add_hard_disk(250_000)

    error = assert_raises(RuntimeError) { builder.computer }
    assert_match(/Not enough memory/, error.message)
  end

  def test_too_many_drives
    builder = DesktopBuilder.new
    5.times { builder.add_cd }

    error = assert_raises(RuntimeError) { builder.computer }
    assert_match(/Too many drives/, error.message)
  end

  def test_must_have_hard_disk
    builder = DesktopBuilder.new
    builder.add_cd

    error = assert_raises(RuntimeError) { builder.computer }
    assert_match(/Must have at least one hard disk/, error.message)
  end
end
