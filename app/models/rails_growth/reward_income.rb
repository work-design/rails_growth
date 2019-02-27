class RewardIncome < ApplicationRecord
  belongs_to :reward, counter_cache: :incomes_count
  belongs_to :user

  validates :amount, numericality: { greater_than_or_equal_to: 0 }
  after_save :sync_amount, if: -> { saved_change_to_amount? }

  def sync_amount
    reward.reload
    reward.income_amount += self.reward_amount
    if reward.income_amount == reward.compute_income_amount
      reward.save!
    else
      reward.errors.add :reward_amount, 'not equal'
      logger.error "#{self.class.name}/Reward: #{reward.errors.full_messages.join(', ')}"
      raise ActiveRecord::RecordInvalid.new(reward)
    end
  end

end
