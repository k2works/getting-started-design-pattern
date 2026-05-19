require_relative "command"

class DeleteFile < Command
  def initialize(path)
    super("Delete file: #{path}")
    @path = path
  end

  def execute
    @contents = File.read(@path) if File.exist?(@path)
    File.delete(@path) if File.exist?(@path)
  end

  def unexecute
    File.write(@path, @contents) if @contents
  end
end
