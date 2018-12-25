class UserCoin < ApplicationRecord
  attribute :amount, :decimal, default: 0
  attribute :income_amount, :decimal, default: 0
  attribute :expense_amount, :decimal, default: 0
  belongs_to :user
  has_many :coin_logs, primary_key: :user_id, foreign_key: :user_id

  def today_amount
    td = Date.today
    self.coin_logs.default_where('created_at-gte': td.beginning_of_day, 'created_at-lt': (td + 1).beginning_of_day).sum(:amount)
  end

end
