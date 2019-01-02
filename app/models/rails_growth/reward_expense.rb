class RewardExpense < ApplicationRecord
  include RailsGrowthLog
  belongs_to :reward, counter_cache: :expenses_count
  belongs_to :user, optional: true
  belongs_to :coin, primary_key: :user_id, foreign_key: :user_id, optional: true
  belongs_to :aim, optional: true
  has_one :aim_entity, inverse_of: :reward_expense

  validates :amount, numericality: { greater_than_or_equal_to: 0 }

  after_save :sync_amount, :sync_to_coin, if: -> { saved_change_to_amount? }

  def sync_amount
    reward.reload
    reward.expense_amount += self.amount
    reward.amount -= self.amount
    if reward.expense_amount == reward.reward_expenses.sum(:amount)
      reward.save!
    else
      reward.errors.add :amount, 'not equal'
      raise ActiveRecord::RecordInvalid.new(reward)
    end
  end

  def sync_to_coin
    if user_id
      self.coin || create_coin
      coin.compute_amount
      coin.save!
    end
  end

  def sync_log
    if user_id
      cl = self.coin_log || self.build_coin_log
      cl.title = self.reward.entity&.title
      cl.tag_str = self.aim&.name
      cl.amount = self.amount
      cl.save
    end
  end

end
