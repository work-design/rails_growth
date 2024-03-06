module Growth
  module Model::AimLog
    extend ActiveSupport::Concern

    included do
      attribute :serial_number, :string
      attribute :ip, :string
      attribute :code, :string
      attribute :rewarded, :boolean
      attribute :created_at, :datetime, null: false

      belongs_to :user, class_name: 'Auth::User', optional: true

      belongs_to :aim
      belongs_to :entity, polymorphic: true, optional: true
      belongs_to :aim_entity, ->(o){ where(aim_id: o.aim_id, entity_type: o.entity_type, entity_id: o.entity_id, serial_number: o.serial_number) }, primary_key: :user_id, foreign_key: :user_id, counter_cache: true, optional: true
      belongs_to :aim_entity_ip, ->(o){ where(user_id: o.user_id, aim_id: o.aim_id, entity_type: o.entity_type, entity_id: o.entity_id, serial_number: o.serial_number) }, class_name: 'AimEntity', primary_key: :ip, foreign_key: :ip, counter_cache: true, optional: true
      belongs_to :reward, ->(o){ where(entity_type: o.entity_type) }, primary_key: :entity_id, foreign_key: :entity_id, optional: true

      has_many :same_aim_logs, ->(o){ where(aim_id: o.aim_id, entity_type: o.entity_type, entity_id: o.entity_id, rewarded: nil) }, class_name: 'AimLog', primary_key: :user_id, foreign_key: :user_id

      default_scope -> { order(id: :desc) }

      validates :user_id, presence: true, if: -> { ip.blank? }
      validates :ip, presence: true, if: -> { user_id.blank? }

      before_validation :init_serial, if: :new_record?
      before_create :init_aim_entity
      after_create_commit :sync_aim_entity_state, :cache_entity_logs
    end

    def init_serial
      self.serial_number = init_serial_number
    end

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

    def cache_entity_logs
      entity&.cache_entity_logs
    end

    def sync_aim_entity_state
      return unless reward_available?

      if aim.reward_point > 0 && aim_entity.aim_logs_count.to_i >= aim.reward_point.to_i
        aim_entity.reward_amount = reward_amount
        aim_entity.commit_reward_done
        self.update(rewarded: true)
        same_aim_logs.update_all(rewarded: false)
      end
    end

    def reward_available?
      user && reward&.available?
    end

    def reward_amount
      per = reward.per_piece * aim.rate
      per < reward.amount ? per : reward.amount
    end

    def init_serial_number
      sa = self.same_aim_logs.pluck(:serial_number)
      unless sa.blank?
        return sa.first
      end
      RailsGrowth::SerialNumberHelper.result(created_at, aim.repeat_type)
    end

  end
end
