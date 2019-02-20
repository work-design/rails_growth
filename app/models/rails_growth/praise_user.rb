class PraiseUser < ApplicationRecord

  attribute :amount, :decimal, default: 0

  belongs_to :user
  belongs_to :reward
  has_many :praise_incomes, ->(o){ where(reward_id: o.reward_id) }, foreign_key: :user_id, primary_key: :user_id

  after_initialize if: :new_record? do
    self.entity_type = reward.entity_type
    self.entity_id = reward.entity_id
  end

  def compute_amount
    self.praise_incomes.sum(:amount)
  end

end
