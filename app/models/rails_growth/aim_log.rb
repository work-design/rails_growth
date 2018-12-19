class AimLog < ApplicationRecord
  belongs_to :aim
  belongs_to :user, optional: true
  belongs_to :aim_user, ->(o){ where(aim_id: o.aim_id, entity_type: o.entity_type, entity_id: o.entity_id, serial_number: o.serial_number) }, primary_key: :user_id, foreign_key: :user_id, counter_cache: true, optional: true
  belongs_to :aim_ip, ->(o){ where(aim_id: o.aim_id, entity_type: o.entity_type, entity_id: o.entity_id, serial_number: o.serial_number) }, class_name: 'AimUser', primary_key: :ip, foreign_key: :ip, counter_cache: true, optional: true
  belongs_to :entity, polymorphic: true

  validates :user_id, presence: true, if: -> { ip.blank? }
  validates :ip, presence: true, if: -> { user_id.blank? }

  after_create_commit :check_aim_user

  def check_aim_user
    if self.user_id
      self.aim_user || create_aim_user
    elsif self.ip
      self.aim_ip || create_aim_ip
    end
  end

  def serial_number
    return @serial_number if defined?(@serial_number)

    year = created_at.year
    if aim.repeat_type == 'daily'
      number = created_at.yday
    elsif aim.repeat_type == 'weekly'
      number = created_at.cweek
    elsif aim.repeat_type == 'monthly'
      number = created_at.month
    elsif aim.repeat_type == 'yearly'
      year = created_at.year
      number = ''
    else
      year = ''
      number = ''
    end

    @serial_number = [year, number].join('-')
  end

end
