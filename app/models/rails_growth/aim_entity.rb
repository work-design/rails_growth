class AimEntity < ApplicationRecord
  belongs_to :aim, optional: true
  belongs_to :user, optional: true
  belongs_to :entity, polymorphic: true, optional: true
  belongs_to :aim_user, ->(o){ where(aim_id: o.aim_id, serial_number: o.serial_number) }, primary_key: :user_id, foreign_key: :user_id, counter_cache: true, optional: true
  has_many :aim_logs, ->(o){ where(user_id: o.user_id, entity_type: o.entity_type, entity_id: o.entity_id) }, foreign_key: :aim_id, primary_key: :aim_id

  belongs_to :reward, ->(o){ where(entity_type: o.entity_type) }, primary_key: :entity_id, foreign_key: :entity_id, optional: true
  belongs_to :reward_expense, inverse_of: :aim_entity, optional: true

  validates :user_id, presence: true, uniqueness: { scope: [:aim_id, :serial_number, :entity_type, :entity_id] }, if: -> { ip.blank? }
  validates :ip, presence: true, uniqueness: { scope: [:aim_id, :serial_number, :entity_type, :entity_id] }, if: -> { user_id.blank? }

  before_create :check_aim_user

  def check_aim_user
    if self.user_id
      self.aim_user || create_aim_user
      if aim.task_point.nil? || aim.task_point >= aim_user.aim_entities_count.to_i
        self.meaningful = true
      end
    end
  end

  def to_reward
    if self.user && reward&.available?
      self.reward_amount = reward.per_piece
      self.reward_expense || self.create_reward_expense!(reward_id: reward.id, amount: self.reward_amount)
    end
  end

end
