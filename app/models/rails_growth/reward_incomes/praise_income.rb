class PraiseIncome < RewardIncome
  attribute :amount, :decimal, default: 0  # 用户打赏
  attribute :profit_amount, :decimal, default: 0  # 平台收入
  attribute :royalty_amount, :decimal, default: 0  # 作者分成
  attribute :reward_amount, :decimal, default: 0  # 赏金池

  belongs_to :gift, foreign_key: :source_id, counter_cache: true
  belongs_to :praise_user, ->(o){ where(reward_id: o.reward_id) }, foreign_key: :user_id, primary_key: :user_id, optional: true

  has_one :wallet_log, ->(o){ where(wallet_id: o.user.wallet_id) }, as: :source
  has_one :coin_log, ->(o){ where(user_id: o.user_id) }, as: :source

  before_save :split_amount, if: -> { amount_changed? }
  after_save :sync_to_account, if: -> { saved_change_to_amount? }
  after_create_commit :sync_log, :sync_to_praise_user

  delegate :name, to: :praise_user, prefix: :user

  acts_as_notify :default,
                 only: [:amount],
                 methods: [:user_name]

  def sync_to_account
    if RailsGrowth.config.gift_purchase == 'Coin'
      sync_to_coin
    else
      sync_to_wallet
    end
  end

  def sync_to_coin
    coin = user.coin.reload

    coin.expense_amount += self.amount
    if coin.expense_amount == coin.compute_expense_amount
      coin.save!
    else
      coin.errors.add :expense_amount, 'not equal'
      logger.error "#{self.class.name}/Coin: #{coin.errors.full_messages.join(', ')}"
      raise ActiveRecord::RecordInvalid.new(coin)
    end
  end

  def sync_to_wallet
    wallet = user.wallet.reload

    wallet.expense_amount += self.amount
    if wallet.expense_amount == wallet.compute_expense_amount
      wallet.save!
    else
      wallet.errors.add :expense_amount, 'not equal'
      logger.error "#{self.class.name}/Wallet: #{wallet.errors.full_messages.join(', ')}"
      raise ActiveRecord::RecordInvalid.new(wallet)
    end
  end

  def sync_log
    if RailsGrowth.config.gift_purchase == 'Coin'
      sync_coin_log
    else
      sync_wallet_log
    end
  end

  def sync_wallet_log
    wl = self.wallet_log || self.build_wallet_log
    wl.title = I18n.t('wallet_log.expense.praise_income.title')
    wl.tag_str = I18n.t('wallet_log.expense.praise_income.tag_str')
    wl.amount = -self.amount
    wl.save
  end

  def sync_coin_log
    cl = self.coin_log || self.build_coin_log
    cl.title = I18n.t('coin_log.expense.praise_income.title')
    cl.tag_str = I18n.t('coin_log.expense.praise_income.tag_str')
    cl.amount = -self.amount
    cl.save
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
