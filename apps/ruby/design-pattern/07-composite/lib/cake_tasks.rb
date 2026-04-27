# frozen_string_literal: true

require_relative "task"
require_relative "composite_task"

# リーフタスク群
class AddDryIngredientsTask < Task
  def initialize
    super("乾燥材料を加える")
  end

  def get_time_required
    1.0
  end
end

class AddLiquidsTask < Task
  def initialize
    super("液体材料を加える")
  end

  def get_time_required
    1.0
  end
end

class MixTask < Task
  def initialize
    super("混ぜる")
  end

  def get_time_required
    3.0
  end
end

class FillPanTask < Task
  def initialize
    super("型に流し込む")
  end

  def get_time_required
    2.0
  end
end

class BakeTask < Task
  def initialize
    super("焼く")
  end

  def get_time_required
    10.0
  end
end

class FrostTask < Task
  def initialize
    super("アイシングする")
  end

  def get_time_required
    4.0
  end
end

class LickSpoonTask < Task
  def initialize
    super("スプーンをなめる")
  end

  def get_time_required
    1.0
  end
end

# 複合タスク: 生地を作る
class MakeBatterTask < CompositeTask
  def initialize
    super("生地を作る")
    add_sub_task(AddDryIngredientsTask.new)
    add_sub_task(AddLiquidsTask.new)
    add_sub_task(MixTask.new)
  end
end

# 複合タスク: ケーキを作る
class MakeCakeTask < CompositeTask
  def initialize
    super("ケーキを作る")
    add_sub_task(MakeBatterTask.new)
    add_sub_task(FillPanTask.new)
    add_sub_task(BakeTask.new)
    add_sub_task(FrostTask.new)
    add_sub_task(LickSpoonTask.new)
  end
end
