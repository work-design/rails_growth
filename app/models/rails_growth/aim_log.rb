class AimLog < ApplicationRecord
  belongs_to :aim
  belongs_to :user, optional: true
  belongs_to :aim_entity, ->(o){ where(aim_id: o.aim_id, entity_type: o.entity_type, entity_id: o.entity_id, serial_number: o.serial_number) }, primary_key: :user_id, foreign_key: :user_id, counter_cache: true, optional: true
  belongs_to :aim_entity_ip, ->(o){ where(user_id: o.user_id, aim_id: o.aim_id, entity_type: o.entity_type, entity_id: o.entity_id, serial_number: o.serial_number) }, class_name: 'AimEntity', primary_key: :ip, foreign_key: :ip, counter_cache: true, optional: true
  belongs_to :entity, polymorphic: true, optional: true

  validates :user_id, presence: true, if: -> { ip.blank? }
  validates :ip, presence: true, if: -> { user_id.blank? }

  before_create :check_aim_user

  def check_aim_user
    if self.user_id
      if self.aim_entity
        self.aim_entity
      else
        self.rewarded = true
        create_aim_entity!
        aim_entity.to_reward
      end
    elsif self.ip
      self.aim_entity_ip || create_aim_entity_ip
    end
  end

  def serial_number
    return @serial_number if defined?(@serial_number)

    @serial_number = SerialNumberHelper.result(created_at, aim.repeat_type)
  end

end
