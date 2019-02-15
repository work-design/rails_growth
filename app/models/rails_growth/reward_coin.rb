class RewardCoin < ApplicationRecord
  has_many :praise_incomes, as: :source

end
