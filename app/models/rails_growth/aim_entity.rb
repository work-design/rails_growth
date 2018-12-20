class AimEntity < ApplicationRecord
  attribute :state, :string, default: 'doing'
  belongs_to :aim
  belongs_to :user, optional: true
  belongs_to :entity, polymorphic: true
  belongs_to :aim_user, ->(o){ where(aim_id: o.aim_id, serial_number: o.serial_number) }, primary_key: :user_id, foreign_key: :user_id, counter_cache: true, optional: true
  belongs_to :aim_ip, ->(o){ where(aim_id: o.aim_id, serial_number: o.serial_number) }, primary_key: :ip, foreign_key: :ip, counter_cache: true, optional: true
  has_many :aim_logs, ->(o){ where(user_id: o.user_id, entity_type: o.entity_type, entity_id: o.entity_id) }, foreign_key: :aim_id, primary_key: :aim_id

  enum state: {
    doing: 'doing',
    done: 'done'
  }

  validates :user_id, presence: true, uniqueness: { scope: [:aim_id, :serial_number, :entity_type, :entity_id] }, if: -> { ip.blank? }
  validates :ip, presence: true, uniqueness: { scope: [:aim_id, :serial_number, :entity_type, :entity_id] }, if: -> { user_id.blank? }

  after_create_commit :check_aim_user

  def check_aim_user
    if self.user_id
      self.aim_user || create_aim_user
    elsif self.ip
      self.aim_ip || create_aim_ip
    end
  end

end
