class AddLiquidsTask < Task
  def initialize
    super('Add Liquids')
  end

  def get_time_required
    1.0 # 水を加えるのに１分
  end
end
