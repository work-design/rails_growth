module RailsGrowthEntity
  extend ActiveSupport::Concern
  included do
    has_one :reward, as: :entity
    has_many :aim_entities, as: :entity
  end

  def init_reward
    self.reward || self.create_reward
  end

  def rewardable
    reward && reward.amount.to_d > 0
  end

end
