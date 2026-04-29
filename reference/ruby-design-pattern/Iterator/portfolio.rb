#
# == ポートフォリオクラス
#
# Author:: k2works
# Version:: 1.0.0
# License:: Ruby License
#
class Portfolio
  include Enumerable

  def initialize
    @accounts = []
  end

  def each(&block)
    @accounts.each(&block)
  end

  def add_account(account)
    @accounts << account
  end
end
