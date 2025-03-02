module Growth
  module Model::PraiseIncome
    extend ActiveSupport::Concern

    included do
      attribute :amount, :decimal, precision: 10, scale: 2, default: 0, comment: '用户打赏'
      attribute :profit_amount, :decimal, precision: 10, scale: 2, default: 0, comment: '平台收入'
      attribute :royalty_amount, :decimal, precision: 10, scale: 2, default: 0, comment: '作者分成'
      attribute :reward_amount, :decimal, precision: 10, scale: 2, default: 0, comment: '赏金池'
      attribute :state, :string, default: 'init'

      belongs_to :reward
      belongs_to :user
      belongs_to :earner, class_name: 'User', optional: true
      belongs_to :source, polymorphic: true, counter_cache: true
      belongs_to :praise_user, ->(o){ where(reward_id: o.reward_id) }, foreign_key: :user_id, primary_key: :user_id, optional: true

      has_many :wallet_logs, ->(o){ where(wallet_id: o.user.wallet_id) }, as: :source
      has_many :royalty_wallet_logs, ->(o){ where(wallet_id: o.earner.wallet_id) }, class_name: 'WalletLog', as: :source
      has_many :coin_logs, ->(o){ where(user_id: o.user_id) }, as: :source
      has_many :royalty_coin_logs, ->(o){ where(user_id: o.earner_id) }, class_name: 'CoinLog', as: :source

      before_save :sync_earner
      before_save :split_amount, if: -> { amount_changed? }
      after_save :sync_to_reward, if: -> { saved_change_to_reward_amount? }
      after_create_commit :sync_to_praise_user, :sync_to_notification

      delegate :name, to: :user, prefix: :user
      delegate :name, to: :gift, prefix: :gift

      enum :state, {
        init: 'init',
        royalty_done: 'royalty_done'
      }

      acts_as_notify(
        :default,
        only: [:amount],
        methods: [:user_name, :gift_name]
      )
    end

    def sync_earner
      author_id = reward.entity.respond_to?(:author) && reward.entity.author_id
      self.earner_id = author_id
    end

    def sync_to_reward
      reward.reload
      reward.income_amount += self.reward_amount
      compute_amount = reward.compute_income_amount
      if reward.income_amount == compute_amount
        reward.save!
      else
        reward.errors.add :reward_amount, "#{reward.income_amount} not equal #{compute_amount}"
        logger.error "#{self.class.name}/Reward: #{reward.errors.full_messages.join(', ')}"
        raise ActiveRecord::RecordInvalid.new(reward)
      end
    end

    def sync_to_praise_user
      pu = self.praise_user || self.build_praise_user
      pu.amount = pu.compute_amount
      pu.save!
    end

    def split_amount
      self.reward_amount = amount * RailsGrowth.config.rate_to_reward
      self.royalty_amount = amount * RailsGrowth.config.rate_to_royalty
      self.profit_amount = self.amount - reward_amount - royalty_amount
    end

    def sync_to_notification
      to_notification(
        receiver: self.reward.entity.user,
        sender: self.praise_user,
        verbose: true
      )
    end

  end
end
