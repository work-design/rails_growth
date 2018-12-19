class RewardExpense < ApplicationRecord
  belongs_to :reward, counter_cache: :expenses_count

  after_save :sync_amount, if: -> { amount_changed? }

  def sync_amount
    reward.compute_amount
    reward.save!
  end

end
