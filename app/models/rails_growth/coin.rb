class Coin < ApplicationRecord
  attribute :amount, :decimal, default: 0
  attribute :income_amount, :decimal, default: 0
  attribute :expense_amount, :decimal, default: 0
  belongs_to :user
  has_many :coin_logs, primary_key: :user_id, foreign_key: :user_id
  has_many :reward_expenses, primary_key: :user_id, foreign_key: :user_id
  has_many :coin_cashes, primary_key: :user_id, foreign_key: :user_id
  has_many :coin_wallets, primary_key: :user_id, foreign_key: :user_id

  validates :user_id, uniqueness: true, presence: true
  validates :amount, numericality: { greater_than_or_equal_to: 0 }

  def today_amount
    td = Date.today
    self.coin_logs.default_where('created_at-gte': td.beginning_of_day, 'created_at-lt': (td + 1).beginning_of_day).sum(:amount)
  end

  def compute_amount
    self.income_amount = self.reward_expenses.sum(:amount)
    cash_sum = self.coin_cashes.sum(:coin_amount)
    wallet_sum = self.coin_wallets.sum(:coin_amount)
    self.expense_amount = cash_sum + wallet_sum
    self.amount = self.income_amount - self.expense_amount
  end

  def self.reset_position
    self.order(income_amount: :desc).each.with_index(1) do |item, index|
      item.update_column :position, index
    end
  end

end
