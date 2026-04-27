# frozen_string_literal: true

require_relative "account"

# ポートフォリオクラス（Iterator パターン - Enumerable を活用）
#
# Enumerable を include し、each を実装することで
# Ruby の豊富なイテレーションメソッドが使える。
class Portfolio
  include Enumerable

  def initialize
    @accounts = []
  end

  def add_account(account)
    @accounts << account
  end

  def each(&block)
    @accounts.each(&block)
  end
end
