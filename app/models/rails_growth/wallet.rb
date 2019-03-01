require_dependency 'rails_wallet/wallet'
class Wallet < ApplicationRecord
  has_many :praise_incomes, primary_key: :user_id, foreign_key: :user_id
  has_many :earned_incomes, class_name: 'PraiseIncome', primary_key: :user_id, foreign_key: :earner_id

  alias_method :origin_compute_expense_amount, :compute_expense_amount
  def compute_expense_amount
    origin_amount = origin_compute_expense_amount

    if RailsGrowth.config.gift_purchase == 'Wallet'
      praise_amount = self.praise_incomes.sum(:amount)
    else
      praise_amount = 0
    end

    origin_amount + praise_amount
  end

  alias_method :origin_compute_income_amount, :compute_income_amount
  def compute_income_amount
    origin_amount = origin_compute_income_amount

    if RailsGrowth.config.gift_purchase == 'Wallet'
      earned_amount = self.earned_incomes.sum(:royalty_amount)
    else
      earned_amount = 0
    end

    origin_amount + earned_amount
  end

end
