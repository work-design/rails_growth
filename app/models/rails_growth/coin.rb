require_dependency 'rails_wallet/coin'
class Coin < ApplicationRecord
  has_many :praise_incomes, primary_key: :user_id, foreign_key: :user_id
  has_many :aim_users, primary_key: :user_id, foreign_key: :user_id
  has_many :reward_expenses, primary_key: :user_id, foreign_key: :user_id

  alias_method :origin_compute_expense_amount, :compute_expense_amount
  def compute_expense_amount
    origin_amount = origin_compute_expense_amount

    if RailsGrowth.config.gift_purchase == 'Coin'
      praise_amount = self.praise_incomes.sum(:amount)
    else
      praise_amount = 0
    end

    if RailsGrowth.config.reward_purchase == 'Coin'
      reward_amount = self.reward_expenses.sum(:amount)
    else
      reward_amount = 0
    end

    origin_amount + reward_amount + praise_amount
  end

  alias_method :origin_compute_income_amount, :compute_income_amount
  def compute_income_amount
    origin_amount = origin_compute_income_amount
    aim_amount = self.aim_users.sum(:coin_amount)
    origin_amount + aim_amount
  end

  def commit_praise_coin
    coin.income_amount += self.royalty_amount
  end

end
