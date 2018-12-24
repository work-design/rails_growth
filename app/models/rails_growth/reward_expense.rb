class RewardExpense < ApplicationRecord
  include RailsGrowthLog
  belongs_to :reward, counter_cache: :expenses_count
  belongs_to :user, optional: true
  belongs_to :aim, optional: true
  has_one :aim_entity, inverse_of: :reward_expense

  after_save :sync_amount, if: -> { saved_change_to_amount? }
  after_initialize if: :new_record? do
    self.aim_id = self.aim_entity&.aim_id
    self.user_id = self.aim_entity&.user_id
  end

  def sync_amount
    reward.reload
    reward.compute_amount
    reward.save!
  end

  def sync_log
    cl = self.coin_log || self.build_coin_log
    cl.title = self.aim.name
    cl.amount = self.amount
    cl.save
  end

end
