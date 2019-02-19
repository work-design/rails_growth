class Reward < ApplicationRecord

  attribute :income_amount, :decimal, default: 0
  attribute :expense_amount, :decimal, default: 0

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

  def reset_amount
    self.income_amount = self.reward_incomes.sum(:amount)
    self.expense_amount = self.reward_expenses.sum(:amount)
    self.changes
  end

  def reset_amount!
    self.reset_amount
    self.save
  end

  def per_piece
    if self.amount > 0
      r = self.max_piece - 1 / (self.amount + 1/(self.max_piece - min_piece))
    else
      r = 0
    end
    pad = (max_piece - r)

    rand((r - pad)..(r + pad)).round(2)
  end

  def self.entity_types
    self.distinct(:entity_type).pluck(:entity_type)
  end

end
