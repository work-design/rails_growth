class UserCoin < ApplicationRecord
  attribute :amount, :decimal, default: 0
  attribute :income_amount, :decimal, default: 0
  attribute :expense_amount, :decimal, default: 0
  belongs_to :user

end
