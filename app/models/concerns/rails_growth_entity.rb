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
  def access_count(timestamp, type, aim_code)
    aim = Aim.find_by(code: aim_code)
    return 0 unless aim

    sn = SerialNumberHelper.result(timestamp, type)
    aim_entities.default_where(aim_id: aim.id, 'serial_number-ll': sn).count
  end

end
