module RailsGrowthEntity
  extend ActiveSupport::Concern
  included do
    has_one :reward, as: :entity
    has_many :aim_entities, as: :entity
  end

  def per_reward
    0.01
  end

end
