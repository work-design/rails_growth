class RewardExpense < ApplicationRecord
  belongs_to :reward, counter_cache: :expenses_count
  belongs_to :aim_entity
  belongs_to :user
  belongs_to :aim

  after_save :sync_amount, if: -> { saved_change_to_amount? }
  after_initialize if: :new_record? do
    self.aim_id = self.aim_entity.aim_id
    self.user_id = self.aim_entity.user_id
  end

  def sync_amount
    reward.reload
    reward.compute_amount
    reward.save!
  end

end
