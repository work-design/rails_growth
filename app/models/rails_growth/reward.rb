class Reward < ApplicationRecord
  belongs_to :entity, polymorphic: true
  has_many :reward_incomes, dependent: :destroy
  has_many :reward_expenses, dependent: :destroy
  has_many :aim_users, ->(o){ where(entity_type: o.entity_type) }, primary_key: :entity_id, foreign_key: :entity_id


  def compute_amount
    self.income_amount = self.reward_incomes.sum(:amount)
    self.expense_amount = self.reward_expenses.sum(:amount)
    self.amount = self.income_amount + self.expense_amount
  end

end
