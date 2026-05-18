class CompositeTask < Task
  def initialize(name)
    super(name)
    @sub_tasks = []
  end

  def add_sub_task(task)
    @sub_tasks << task
    task.parent = self
  end

  def remove_sub_task(task)
    @sub_tasks.delete(task)
    task.parent = nil
  end

  def get_time_required
    @sub_tasks.sum(&:get_time_required)
  end

  def total_number_basic_tasks
    @sub_tasks.sum(&:total_number_basic_tasks)
  end
end
