class AimLog < ApplicationRecord
  belongs_to :aim
  belongs_to :user, optional: true
  belongs_to :aim_entity, ->(o){ where(aim_id: o.aim_id, entity_type: o.entity_type, entity_id: o.entity_id, serial_number: o.serial_number) }, primary_key: :user_id, foreign_key: :user_id, counter_cache: true, optional: true
  belongs_to :aim_entity_ip, ->(o){ where(user_id: o.user_id, aim_id: o.aim_id, entity_type: o.entity_type, entity_id: o.entity_id, serial_number: o.serial_number) }, class_name: 'AimEntity', primary_key: :ip, foreign_key: :ip, counter_cache: true, optional: true
  belongs_to :entity, polymorphic: true, optional: true
  belongs_to :reward, ->(o){ where(entity_type: o.entity_type) }, primary_key: :entity_id, foreign_key: :entity_id, optional: true

  default_scope -> { order(id: :desc) }

  validates :user_id, presence: true, if: -> { ip.blank? }
  validates :ip, presence: true, if: -> { user_id.blank? }

  before_create :init_aim_entity
  after_create_commit :sync_aim_entity_state

  def init_aim_entity
    if self.user_id
      if self.aim_entity
        self.aim_entity
      else
        create_aim_entity
      end
    elsif self.ip
      self.aim_entity_ip || create_aim_entity_ip
    end
  end

  def sync_aim_entity_state
    return unless reward_available?

    if aim_entity.aim_logs_count.to_i >= aim.reward_point.to_i
      aim_entity.reward_amount = reward_amount
      aim_entity.commit_reward_done
      self.rewarded = true
    end
  end

  def reward_available?
    user && reward&.available?
  end

  def reward_amount
    per = reward.per_piece * aim.rate
    per < reward.amount ? per : reward.amount
  end

  def serial_number
    return @serial_number if defined?(@serial_number)

    @serial_number = SerialNumberHelper.result(created_at, aim.repeat_type)
  end

end
