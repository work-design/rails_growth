class PraiseIncome < RewardIncome
  belongs_to :gift, foreign_key: :source_id, counter_cache: true

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
      raise ActiveRecord::RecordInvalid.new(wallet)
    end
  end

  def sync_wallet_log
    wl = self.wallet_log || self.build_wallet_log
    wl.title = I18n.t('wallet_log.expense.coin_wallet.title')
    wl.tag_str = I18n.t('wallet_log.expense.coin_wallet.tag_str')
    wl.amount = self.wallet_amount
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
