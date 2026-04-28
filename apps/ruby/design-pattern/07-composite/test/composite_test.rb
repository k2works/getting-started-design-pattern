# frozen_string_literal: true

require_relative '../../test/test_helper'
require_relative '../lib/cake_tasks'

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

  def test_add_and_remove_sub_task
    composite = CompositeTask.new('テスト')
    task = MixTask.new

    composite.add_sub_task(task)
    assert_equal composite, task.parent
    assert_equal 3.0, composite.get_time_required

    composite.remove_sub_task(task)
    assert_nil task.parent
    assert_equal 0.0, composite.get_time_required
  end

  def test_array_access
    cake = MakeCakeTask.new
    assert_equal '生地を作る', cake[0].name
    assert_equal '型に流し込む', cake[1].name
  end

  def test_parent_child_relationship
    cake = MakeCakeTask.new
    batter = cake[0]
    assert_equal cake, batter.parent
  end
end
