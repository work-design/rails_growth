class CoinWallet < CoinExchange
  alias_attribute :wallet_amount, :amount

  belongs_to :wallet
  has_one :wallet_log, ->(o){ where(wallet_id: o.wallet_id) }, as: :source

  validates :coin_amount, numericality: { greater_than_or_equal_to: 1 }

  after_initialize if: :new_record? do
    self.state = 'done'
    self.wallet_amount = self.coin_amount / 100
    self.wallet = user.wallet
  end
  after_create_commit :sync_wallet_log

  def sync_to_coin
    (self.coin && coin.reload) || create_coin

    coin.expense_amount += self.coin_amount
    if coin.expense_amount == coin.coin_exchanges.sum(:coin_amount)
      coin.save!
    else
      coin.errors.add :income_amount, 'not equal'
      raise ActiveRecord::RecordInvalid.new(coin)
    end

    wallet.reload
    wallet.income_amount += self.amount
    if wallet.income_amount == wallet.compute_income_amount
      wallet.save!
    else
      wallet.errors.add :income_amount, 'not equal'
      raise ActiveRecord::RecordInvalid.new(wallet)
    end
  end

  def sync_wallet_log
    wl = self.wallet_log || self.build_wallet_log
    wl.title = I18n.t('wallet_log.income.coin_wallet.title')
    wl.tag_str = I18n.t('wallet_log.income.coin_wallet.tag_str')
    wl.amount = -self.wallet_amount
    wl.save
  end

  def sync_coin_log
    cl = self.coin_log || self.build_coin_log
    cl.title = I18n.t('coin_log.expense.coin_wallet.title')
    cl.tag_str = I18n.t('coin_log.expense.coin_wallet.tag_str')
    cl.amount = -self.coin_amount
    cl.save
  end

end
