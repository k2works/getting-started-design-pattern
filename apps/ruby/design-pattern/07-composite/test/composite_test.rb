require_relative "test_helper"
require_relative "../lib/task"
require_relative "../lib/composite_task"
require_relative "../lib/tasks"

class CompositeTest < Minitest::Test
  def test_make_batter_task_time
    batter = MakeBatterTask.new
    assert_equal 5.0, batter.get_time_required
  end

  def test_make_cake_task_time
    cake = MakeCakeTask.new
    assert_equal 22.0, cake.get_time_required
  end

  def test_total_number_of_basic_tasks
    cake = MakeCakeTask.new
    assert_equal 7, cake.total_number_basic_tasks
  end
end
