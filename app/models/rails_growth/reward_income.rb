class RewardIncome < ApplicationRecord
  belongs_to :reward, counter_cache: :incomes_count

  after_save :sync_amount, if: -> { saved_change_to_amount? }

  def sync_amount
    reward.reload
    reward.compute_amount
    reward.save!
  end

end
