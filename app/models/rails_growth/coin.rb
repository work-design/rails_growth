require_dependency 'rails_wallet/coin'
puts 'from rails growth'
class Coin < ApplicationRecord
  has_many :praise_incomes, primary_key: :user_id, foreign_key: :user_id
  has_many :aim_users, primary_key: :user_id, foreign_key: :user_id

  alias_method :origin_compute_expense_amount, :compute_expense_amount
  def compute_expense_amount
    origin_amount = origin_compute_expense_amount
    praise_amount = self.praise_incomes.sum(:amount)
    origin_amount + praise_amount
  end

  alias_method :origin_compute_income_amount, :compute_income_amount
  def compute_income_amount
    origin_amount = origin_compute_income_amount
    aim_amount = self.aim_incomes.sum(:coin_amount)
    origin_amount + aim_amount
  end

end
