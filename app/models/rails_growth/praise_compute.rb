module RailsGrowth::PraiseCompute
  extend ActiveSupport::Concern
  included do
    after_save :sync_to_praise_account, if: -> { saved_change_to_amount? }
    after_create_commit :sync_praise_log, if: -> { saved_change_to_amount? }
  end

  def sync_to_praise_account
    if RailsGrowth.config.gift_purchase == 'Coin'
      sync_to_praise_coin
    else
      sync_to_praise_wallet
    end
  end

  def sync_to_praise_coin
    coin = user.coin.reload

    coin.expense_amount += self.amount
    compute_amount = coin.compute_expense_amount
    if coin.expense_amount == compute_amount
      coin.save!
    else
      coin.errors.add :expense_amount, "Praise:#{coin.expense_amount} not equal #{compute_amount}"
      logger.error "#{self.class.name}/Coin: #{coin.errors.full_messages.join(', ')}"
      raise ActiveRecord::RecordInvalid.new(coin)
    end
  end

  def sync_to_praise_wallet
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

  def sync_praise_log
    if RailsGrowth.config.gift_purchase == 'Coin'
      sync_praise_coin_log
    else
      sync_praise_wallet_log
    end
  end

  def sync_praise_wallet_log
    wl = self.wallet_logs.build
    wl.title = I18n.t('wallet_log.expense.praise_income.title')
    wl.tag_str = I18n.t('wallet_log.expense.praise_income.tag_str')
    wl.amount = -self.amount
    wl.save
  end

  def sync_praise_coin_log
    cl = self.coin_logs.build
    cl.title = I18n.t('coin_log.expense.praise_income.title')
    cl.tag_str = I18n.t('coin_log.expense.praise_income.tag_str')
    cl.amount = -self.amount
    cl.save
  end

end
