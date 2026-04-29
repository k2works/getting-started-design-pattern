#
# == コンポジットクラス
#
# Author:: k2works
# Version:: 1.0.0
# License:: Ruby License
#
class CompositeCommand < Command
  def initialize
    @commands = []
  end

  def add_command(cmd)
    @commands << cmd
  end

  def execute
    @commands.each {|cmd| cmd.execute}
  end

  def unexecute
    @commands.reverse.each {|cmd| cmd.unexecute }
  end

  def description
    description = ''
    @commands.each {|cmd| description += cmd.description + "\n"}
    description
  end
end
