class CoinWallet < ApplicationRecord
  belongs_to :user
  belongs_to :coin, primary_key: :user_id, foreign_key: :user_id
  belongs_to :wallet, primary_key: :user_id, foreign_key: :user_id

  has_one :wallet_log, as: :source, primary_key: :user_id, foreign_key: :user_id
  has_one :coin_log, as: :source, primary_key: :user_id, foreign_key: :user_id

  enum state: {
    verified: 'verified',
    done: 'done'
  }

  after_initialize if: :new_record? do
    self.wallet_amount = self.coin_amount / 100
  end
  after_save :sync_to_coin, if: -> { saved_change_to_coin_amount? }
  after_create_commit :sync_wallet_log, :sync_coin_log

  def title
    '微信提现'
  end

  def sync_wallet_log
    cl = self.wallet_log || self.build_wallet_log
    cl.title = '金币兑换'
    cl.tag_str = '兑换收入'
    cl.amount = self.wallet_amount
    cl.save
  end

  def sync_coin_log
    cl = self.coin_log || self.build_coin_log
    cl.title = '兑换虚拟币'
    cl.tag_str = '兑换支出'
    cl.amount = self.coin_amount
    cl.save
  end

  def sync_to_coin
    self.coin || create_coin
    coin.compute_amount
    coin.save!

    self.wallet || create_wallet
    wallet.compute_amount
    wallet.save!
  end

end
