module RoyaltyCompute
  extend ActiveSupport::Concern
  included do
    after_save :sync_to_royalty_account, if: -> { saved_change_to_royalty_amount? }
    after_create_commit :sync_royalty_log, if: -> { saved_change_to_royalty_amount? }
  end

  def sync_to_royalty_account
    if RailsGrowth.config.gift_purchase == 'Coin'
      sync_to_royalty_coin
    else
      sync_to_royalty_wallet
    end
  end

  def sync_to_royalty_coin
    coin = earner.coin.reload

    coin.income_amount += self.royalty_amount
    if coin.income_amount == coin.compute_income_amount
      coin.save!
      coin.to_cash(coin_amount: royalty_amount)
    else
      coin.errors.add :income_amount, 'not equal'
      logger.error "#{self.class.name}/Coin: #{coin.errors.full_messages.join(', ')}"
      raise ActiveRecord::RecordInvalid.new(coin)
    end
  end

  def sync_to_royalty_wallet
    wallet = earner.wallet.reload

    wallet.income_amount += self.royalty_amount
    if wallet.income_amount == wallet.compute_income_amount
      wallet.save!
    else
      wallet.errors.add :income_amount, 'not equal'
      logger.error "#{self.class.name}/Wallet: #{wallet.errors.full_messages.join(', ')}"
      raise ActiveRecord::RecordInvalid.new(wallet)
    end
  end

  def sync_royalty_log
    if RailsGrowth.config.gift_purchase == 'Coin'
      sync_royalty_coin_log
    else
      sync_royalty_wallet_log
    end
  end

  def sync_royalty_wallet_log
    wl = self.wallet_logs.build
    wl.title = I18n.t('wallet_log.income.praise_income.title')
    wl.tag_str = I18n.t('wallet_log.income.praise_income.tag_str')
    wl.amount = self.royalty_amount
    wl.save
  end

  def sync_royalty_coin_log
    cl = self.coin_logs.build
    cl.title = I18n.t('coin_log.income.praise_income.title')
    cl.tag_str = I18n.t('coin_log.income.praise_income.tag_str')
    cl.amount = self.royalty_amount
    cl.save
  end

end
