class PraiseIncome < ApplicationRecrod
  include PraiseCompute
  include RoyaltyCompute

  attribute :amount, :decimal, default: 0  # 用户打赏
  attribute :profit_amount, :decimal, default: 0  # 平台收入
  attribute :royalty_amount, :decimal, default: 0  # 作者分成
  attribute :reward_amount, :decimal, default: 0  # 赏金池
  attribute :state, :string, default: 'init'

  belongs_to :reward
  belongs_to :user
  belongs_to :gift, foreign_key: :source_id, counter_cache: true
  belongs_to :praise_user, ->(o){ where(reward_id: o.reward_id) }, foreign_key: :user_id, primary_key: :user_id, optional: true

  has_one :wallet_log, ->(o){ where(wallet_id: o.user.wallet_id) }, as: :source
  has_one :coin_log, ->(o){ where(user_id: o.user_id) }, as: :source

  before_save :split_amount, if: -> { amount_changed? }
  after_save :sync_to_reward, if: -> { saved_change_to_reward_amount? }
  after_create_commit :sync_to_praise_user,
                      :sync_to_notification

  delegate :name, to: :user, prefix: :user
  delegate :name, to: :gift, prefix: :gift

  enum state: {
    init: 'init',
    royalty_done: 'royalty_done'
  }


  acts_as_notify :default,
                 only: [:amount],
                 methods: [:user_name, :gift_name]

  def sync_earner
    reward.entity.respond_to?(:author) && reward.entity.author_id
    self.earner_id = author_id
  end

  def sync_to_reward
    reward.reload
    reward.income_amount += self.reward_amount
    if reward.income_amount == reward.compute_income_amount
      reward.save!
    else
      reward.errors.add :reward_amount, 'not equal'
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
