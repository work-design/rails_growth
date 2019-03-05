class RewardExpense < ApplicationRecord
  attribute :amount, :decimal, default: 0
  belongs_to :reward
  belongs_to :user, optional: true
  belongs_to :coin, primary_key: :user_id, foreign_key: :user_id, optional: true, inverse_of: :reward_expenses
  belongs_to :aim, optional: true
  has_one :aim_entity, inverse_of: :reward_expense
  has_one :coin_log, -> (o){ where(user_id: o.user_id) }, as: :source
  has_one :cash_log, -> (o){ where(user_id: o.user_id) }, as: :source

  validates :amount, numericality: { greater_than_or_equal_to: 0 }

  after_save :sync_to_reward, :sync_to_account, if: -> { saved_change_to_amount? }
  after_create_commit :sync_log

  def sync_to_reward
    reward.reload
    reward.expense_amount += self.amount
    if reward.expense_amount == reward.compute_expense_amount
      reward.save!
    else
      reward.errors.add :expense_amount, 'not equal'
      logger.error "#{self.class.name}/Reward: #{reward.errors.full_messages.join(', ')}"
      raise ActiveRecord::RecordInvalid.new(reward)
    end
  end

  def sync_to_account
    return unless user_id

    if RailsGrowth.config.reward_purchase == 'Coin'
      sync_to_coin
    else
      sync_to_cash
    end
  end

  def sync_to_cash
    cash = user.cash.reload

    cash.income_amount += self.amount
    if cash.income_amount == cash.compute_income_amount
      cash.save!
    else
      cash.errors.add :income_amount, 'not equal'
      logger.error "#{self.class.name}/Cash: #{cash.errors.full_messages.join(', ')}"
      raise ActiveRecord::RecordInvalid.new(cash)
    end
  end

  def sync_to_coin
    coin = user.coin.reload
    compute_amount = coin.compute_income_amount
    coin.income_amount += self.amount
    if coin.income_amount == compute_amount
      coin.save!
    else
      coin.errors.add :income_amount, "Amount: #{coin.income_amount} not equal Compute: #{compute_amount}"
      logger.error "#{self.class.name}/Coin: #{coin.errors.full_messages.join(', ')}"
      raise ActiveRecord::RecordInvalid.new(coin)
    end
  end

  def sync_log
    return unless user_id

    if RailsGrowth.config.reward_purchase == 'Coin'
      sync_coin_log
    else
      sync_cash_log
    end
  end

  def sync_cash_log
    wl = self.cash_log || self.build_cash_log
    wl.title = self.reward.entity&.title
    wl.tag_str = self.aim&.name
    wl.amount = self.amount
    wl.save
  end

  def sync_coin_log
    cl = self.coin_log || self.build_coin_log
    cl.title = self.reward.entity&.title
    cl.tag_str = self.aim&.name
    cl.amount = self.amount
    cl.save
  end

end
