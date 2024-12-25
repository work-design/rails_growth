module Growth
  module Model::AimEntity
    extend ActiveSupport::Concern
    include Inner::Text

    included do
      attribute :present_point, :integer
      attribute :state, :string

      attribute :last_access_at, :datetime
      attribute :ip, :string
      attribute :reward_amount, :decimal, precision: 10, scale: 2
      attribute :aim_logs_count, :integer, default: 0

      belongs_to :entity, polymorphic: true, optional: true
      belongs_to :reward_expense, inverse_of: :aim_entity, optional: true
      belongs_to :aim_user, ->(o){ where(o.filter_hash) }, primary_key: :user_id, foreign_key: :user_id, counter_cache: true, optional: true
      belongs_to :reward, ->(o){ where(entity_type: o.entity_type) }, primary_key: :entity_id, foreign_key: :entity_id, optional: true

      has_many :aim_logs, ->(o){ where(user_id: o.user_id, entity_type: o.entity_type, entity_id: o.entity_id) }, foreign_key: :aim_id, primary_key: :aim_id

      # validates :user_id, presence: true, uniqueness: { scope: [:aim_id, :serial_number, :entity_type, :entity_id] }, if: -> { ip.blank? }
      # validates :ip, presence: true, uniqueness: { scope: [:aim_id, :entity_type, :entity_id] }, if: -> { user_id.blank? }

      before_create :init_aim_user
      after_create_commit :sync_aim_user_state

      enum :state, {
        reward_none: 'reward_none',
        reward_doing: 'reward_doing',
        reward_done: 'reward_done'
      }
    end

    def init_aim_user
      self.aim_user || create_aim_user if self.user_id
      if aim.reward_point == 0
        self.state = 'reward_none'
      else
        self.state = 'reward_doing'
      end
    end

    def sync_aim_user_state
      #aim_user.commit_task_done
    end

    def commit_reward_done
      self.state = 'reward_done'

      self.class.transaction do
        self.save!
        sync_to_reward_expense
      end
    end

    def sync_to_reward_expense
      re = self.reward_expense || self.build_reward_expense
      re.attributes = {
        user_id: user_id,
        aim_id: aim_id,
        reward_id: reward.id,
        amount: self.reward_amount
      }
      re.save!
    end

    def user_name
      user.name.presence || user.id
    end

  end
end
