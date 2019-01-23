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
  after_create_commit :sync_aim_user_state

  enum state: {
    reward_none: 'reward_none',
    reward_doing: 'reward_doing',
    reward_done: 'reward_done'
  }

  def check_aim_user
    self.aim_user || create_aim_user if self.user_id
    if aim.reward_point == 0
      self.state = 'reward_none'
    elsif aim.reward_point == 1
      self.state = 'reward_done'
    else
      self.state = 'reward_doing'
    end
  end

  def sync_aim_user_state
    if aim_user.aim_entities_count.to_i >= aim.task_point.to_i
      self.aim_user.update(state: 'task_done')
    end
    if reward_expense_id
      sync_aim_and_user
    end
  end

  def sync_reward_state
    if self.aim_logs_count.to_i >= aim.reward_point.to_i
      self.update(state: 'reward_done')
    end
  end

  def sync_aim_and_user
    reward_expense.aim_id = self.aim_id
    reward_expense.user_id = self.user_id
    reward_expense.save
  end

  def to_reward
    if self.user && reward.available?
      self.reward_expense || self.create_reward_expense!(user_id: user_id, reward_id: reward.id, amount: self.reward_amount)
    end
  end

end
