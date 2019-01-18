module RailsGrowthEntity
  extend ActiveSupport::Concern
  included do
    attribute :title, :string
    has_one :reward, as: :entity
    has_many :aim_entities, as: :entity
  end

  def init_reward
    self.reward || self.create_reward
  end

  def rewardable
    reward.present? && reward.amount.to_d > 0
  end

  # daily
  # weekly
  # monthly
  # yearly
  def access_count(timestamp, type, aim_id)
    sn = SerialNumberHelper.result(timestamp, type)
    aim_entities.default_where(aim_id: aim_id, 'serial_number-ll': sn).count
  end

end
