module Growth
  module Model::AimUser
    extend ActiveSupport::Concern

    included do
      attribute :text_year, :string
      attribute :state, :string, default: 'task_doing'
      attribute :reward_amount, :integer, default: 0
      attribute :aim_entities_count, :integer, default: 0

      belongs_to :user, class_name: 'Auth::User', optional: true

      belongs_to :aim, optional: true
      has_many :aim_entities, ->(o){ where(user_id: o.user_id) }, foreign_key: :aim_id, primary_key: :aim_id

      enum state: {
        task_doing: 'task_doing',
        task_done: 'task_done'
      }

      after_commit :sync_log, if: -> { saved_change_to_reward_amount? }, on: [:create, :update]
    end

    def progress
      [aim_entities_count.to_i, aim.task_point]
    end

    def commit_task_done
      return if aim.task_point.to_i > aim_entities_count.to_i

      self.state = 'task_done'
      self.reward_amount = aim.reward_amount

      self.class.transaction do
        self.save!
        sync_to_coin
      end
    end

    def sync_log
      cl = self.coin_log || self.build_coin_log
      cl.title = I18n.t('coin_log.income.aim_user.title')
      cl.tag_str = I18n.t('coin_log.income.aim_user.tag_str')
      cl.amount = self.reward_amount
      cl.save
    end

    def sync_to_coin
      coin = user.coin.reload
      coin.income_amount += self.reward_amount
      if coin.income_amount == coin.compute_income_amount
        coin.save!
      else
        coin.errors.add :income_amount, 'not equal'
        logger.error "#{self.class.name}/Coin: #{coin.errors.full_messages.join(', ')}"
        raise ActiveRecord::RecordInvalid.new(coin)
      end
    end

  end
end
