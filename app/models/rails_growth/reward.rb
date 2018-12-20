class Reward < ApplicationRecord
  belongs_to :entity, polymorphic: true
  has_many :reward_incomes, dependent: :destroy
  has_many :reward_expenses, dependent: :destroy
  has_many :aim_users, ->(o){ where(entity_type: o.entity_type) }, primary_key: :entity_id, foreign_key: :entity_id

  validates :max_piece, numericality: { greater_than_or_equal_to: -> (o) { o.min_piece } }
  validates :min_piece, numericality: { less_than_or_equal_to: -> (o) { o.max_piece } }

  def compute_amount
    self.income_amount = self.reward_incomes.sum(:amount)
    self.expense_amount = self.reward_expenses.sum(:amount)
    self.amount = self.income_amount + self.expense_amount
  end

  def pieces

  end

  def available?
    true
  end

  def per_piece
    rand(self.min_piece.to_f..self.max_piece.to_f).round(2)
  end

end
