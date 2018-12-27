class CoinCash < ApplicationRecord
  belongs_to :user
  belongs_to :coin, primary_key: :user_id, foreign_key: :user_id
  has_one :coin_log, as: :source, primary_key: :user_id, foreign_key: :user_id

  after_initialize if: :new_record? do
    self.cash_amount = self.coin_amount / 100
  end
  after_save :sync_to_coin, if: -> { saved_change_to_coin_amount? }
  after_create_commit :sync_coin_log

  def sync_coin_log
    cl = self.coin_log || self.build_coin_log
    cl.title = '提现'
    cl.tag_str = '兑换支出'
    cl.amount = self.coin_amount
    cl.save
  end

  def sync_to_coin
    self.coin || create_coin
    coin.compute_amount
    coin.save!
  end

end
