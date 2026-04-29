require_relative 'expression'
require_relative 'all'
require_relative 'file_name'
require_relative 'bigger'
require_relative 'writable'
require_relative 'not'
require_relative 'or'
require_relative 'and'
#
# == パーサークラス
#
# Author:: k2works
# Version:: 1.0.0
# License:: Ruby License
#
class Parser
  def initialize(text)
    @tokens = text.scan(/\(|\)|[\w\.\*]+/)
  end

  def next_token
    @tokens.shift
  end

  def expression
    token = next_token

    if token == nil
      return nil

    elsif token == '('
      result = expression
      raise 'Expected )' unless next_token == ')'
      result

    elsif token == 'all'
      return All.new

    elsif token == 'writable'
      return Writable.new

    elsif token == 'bigger'
      return Bigger.new(next_token.to_i)

    elsif token == 'filename'
      return FileName.new(next_token)

    elsif token == 'not'
      return Not.new(expression)

    elsif token == 'and'
      return And.new(expression, expression)

    elsif token == 'or'
      return Or.new(expression, expression)

    else
      raise "Unxepected token: #{token}"
    end
  end
end