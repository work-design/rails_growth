class Reward < ApplicationRecord
  belongs_to :entity, polymorphic: true
  has_many :reward_incomes, dependent: :destroy
  has_many :reward_expenses, dependent: :destroy
  has_many :aim_users, ->(o){ where(entity_type: o.entity_type) }, primary_key: :entity_id, foreign_key: :entity_id

  validates :max_piece, numericality: { greater_than_or_equal_to: -> (o) { o.min_piece } }, allow_blank: true
  validates :min_piece, numericality: { less_than_or_equal_to: -> (o) { o.max_piece } }, allow_blank: true
  validates :amount, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true

  before_save :compute_amount, if: -> { income_amount_changed? || expense_amount_changed? }

  def compute_amount
    self.amount = income_amount - expense_amount
  end

  def available?
    enabled? &&
    amount > 0
  end

  def per_piece
    rand(self.min_piece.to_f..self.max_piece.to_f).round(2)
  end

end
