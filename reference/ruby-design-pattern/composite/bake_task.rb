class BakeTask < Task

  def initialize
    super('Bake')
  end

  def get_time_required
    10.0
  end
end