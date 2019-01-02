class Coin < ApplicationRecord
  attribute :amount, :decimal, default: 0
  attribute :income_amount, :decimal, default: 0
  attribute :expense_amount, :decimal, default: 0
  belongs_to :user
  has_many :coin_logs, primary_key: :user_id, foreign_key: :user_id
  has_many :reward_expenses, primary_key: :user_id, foreign_key: :user_id
  has_many :coin_exchanges, primary_key: :user_id, foreign_key: :user_id
  has_many :coin_cashes, primary_key: :user_id, foreign_key: :user_id
  has_many :coin_wallets, primary_key: :user_id, foreign_key: :user_id

  validates :user_id, uniqueness: true, presence: true
  validates :amount, numericality: { greater_than_or_equal_to: 0 }

  before_save :compute_amount

  def today_amount
    td = Date.today
    self.coin_logs.default_where('created_at-gte': td.beginning_of_day, 'created_at-lt': (td + 1).beginning_of_day).sum(:amount)
  end

  def compute_amount
    self.amount = self.income_amount - self.expense_amount
  end

  def self.reset_position
    self.order(income_amount: :desc).each.with_index(1) do |item, index|
      item.update_column :position, index
    end
  end

end
