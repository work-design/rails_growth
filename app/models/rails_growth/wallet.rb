require_dependency 'rails_wallet/wallet'
class Wallet < ApplicationRecord
  has_many :praise_incomes, primary_key: :user_id, foreign_key: :user_id

  alias_method :origin_compute_expense_amount, :compute_expense_amount
  def compute_expense_amount
    origin_amount = origin_compute_expense_amount
    praise_amount = self.praise_incomes.sum(:amount)
    origin_amount + praise_amount
  end

end
