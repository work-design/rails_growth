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

  def init_reward
    self.reward || self.create_reward
  end

  def rewardable
    reward.present? && reward.amount.to_d > 0
  end

  def rewardable_codes(user_id)
    aim_ids = aim_entities.reward_done.where(user_id: user_id).pluck(:aim_id)
    done_codes = Aim.where(id: aim_ids).reward_codes.map { |i| [i, 'reward_done'] }
    available_codes = Aim.where.not(id: aim_ids).reward_codes.map { |i| [i, 'rewardable'] }
    done_codes.to_h.merge available_codes.to_h
  end

  # daily
  # weekly
  # monthly
  # yearly
  def access_count(timestamp, type, aim_code)
    aim_code = AimCode.find_by(code: aim_code)
    return 0 unless aim_code

    sn = SerialNumberHelper.result(timestamp, type)
    aim_entities.default_where(aim_id: aim_code.aim_id, 'serial_number-ll': sn).count
  end

end
