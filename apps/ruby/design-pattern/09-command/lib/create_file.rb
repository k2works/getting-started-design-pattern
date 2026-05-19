require_relative "command"

class CreateFile < Command
  def initialize(path, contents)
    super("Create file: #{path}")
    @path = path
    @contents = contents
  end

  def execute
    File.write(@path, @contents)
  end

  def unexecute
    File.delete(@path) if File.exist?(@path)
  end
end
