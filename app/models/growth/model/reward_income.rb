module RailsGrowth::RewardIncome
  extend ActiveSupport::Concern

  included do
    attribute :reward_amount, :decimal, precision: 10, scale: 2, default: 0

    belongs_to :reward, counter_cache: :incomes_count
    belongs_to :user, optional: true

    validates :reward_amount, numericality: { greater_than_or_equal_to: 0 }
    after_create :sync_to_reward, if: -> { saved_change_to_reward_amount? }
    after_update :reset_to_reward, if: -> { saved_change_to_reward_amount? }
  end

  def sync_to_reward
    reward.reload
    reward.income_amount += self.reward_amount
    compute_amount = reward.compute_income_amount
    if reward.income_amount == compute_amount
      reward.save!
    else
      reward.errors.add :reward_amount, "#{reward.income_amount} not equal #{compute_amount}"
      logger.error "#{self.class.name}/Reward: #{reward.errors.full_messages.join(', ')}"
      raise ActiveRecord::RecordInvalid.new(reward)
    end
  end

  def reset_to_reward
    reward.income_amount = reward.compute_income_amount
    reward.save!
  end

end
