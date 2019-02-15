module RailsGrowthEntity
  extend ActiveSupport::Concern

  included do
    attribute :title, :string
    has_one :reward, as: :entity
    has_many :aim_entities, as: :entity

    def self.entities(user_id)
      joins(:aim_entities).default_where('aim_entities.user_id': user_id, 'aim_entities.entity_type': self.name).order('aim_entities.id DESC')
    end
  end

  def reward
    if super
      super
    else
      create_reward
    end
  end

  def rewardable
    reward.present? && reward.amount.to_d > 0
  end

  def rewardable_codes(user_id)
    return [] unless rewardable
    aim_ids = aim_entities.reward_done.where(user_id: user_id).pluck(:aim_id)
    #done_codes = Aim.where(id: aim_ids).reward_codes
    available_codes = Aim.where.not(id: aim_ids).reward_codes
  end

  # daily
  # weekly
  # monthly
  # yearly
  def entity_count(timestamp, type, aim_code)
    aim_code = AimCode.find_by(code: aim_code)
    return 0 unless aim_code

    sn = SerialNumberHelper.result(timestamp, type)
    aim_entities.default_where(aim_id: aim_code.aim_id, 'serial_number-ll': sn).count
  end

end
