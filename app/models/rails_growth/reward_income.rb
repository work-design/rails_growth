class RewardIncome < ApplicationRecord
  belongs_to :reward, counter_cache: :incomes_count

  validates :amount, numericality: { greater_than_or_equal_to: 0 }
  after_save :sync_amount, if: -> { saved_change_to_amount? }

  def sync_amount
    reward.reload
    reward.income_amount += self.amount
    reward.amount += self.amount
    if reward.income_amount == reward.reward_incomes.sum(:amount)
      reward.save!
    else
      reward.errors.add :amount, 'not equal'
      raise ActiveRecord::RecordInvalid.new(reward)
    end
  end

end
