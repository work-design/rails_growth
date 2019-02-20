class RewardExpense < ApplicationRecord
  include RailsGrowthLog
  belongs_to :reward, counter_cache: :expenses_count
  belongs_to :user, optional: true
  belongs_to :coin, primary_key: :user_id, foreign_key: :user_id, optional: true, inverse_of: :reward_expenses
  belongs_to :aim, optional: true
  has_one :aim_entity, inverse_of: :reward_expense

  validates :amount, numericality: { greater_than_or_equal_to: 0 }

  after_save :sync_amount, :sync_to_coin, if: -> { saved_change_to_amount? }

  def sync_amount
    reward.reload
    reward.expense_amount += self.amount
    if reward.expense_amount == reward.reward_expenses.sum(:amount)
      reward.save!
    else
      reward.errors.add :expense_amount, 'not equal'
      logger.error "Reward: #{reward.errors.full_messages.join(', ')}"
      raise ActiveRecord::RecordInvalid.new(reward)
    end
  end

  def sync_to_coin
    return unless user_id

    (self.coin && coin.reload) || create_coin

    coin.income_amount += self.amount

    if coin.income_amount == coin.reward_expenses.sum(:amount)
      coin.save!
    else
      coin.errors.add :income_amount, 'not equal'
      logger.error "Coin: #{coin.errors.full_messages.join(', ')}"
      raise ActiveRecord::RecordInvalid.new(coin)
    end
  end

  def sync_log
    return unless user_id
    cl = self.coin_log || self.build_coin_log
    cl.title = self.reward.entity&.title
    cl.tag_str = self.aim&.name
    cl.amount = self.amount
    cl.save
  end

end
