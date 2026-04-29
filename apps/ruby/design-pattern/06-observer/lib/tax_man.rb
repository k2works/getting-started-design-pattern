# frozen_string_literal: true

# 税務担当オブザーバー
class TaxMan
  attr_reader :last_notification

  def update(employee)
    @last_notification = "#{employee.name} に新しい税金の請求書を送付します"
    puts(@last_notification)
  end
end
