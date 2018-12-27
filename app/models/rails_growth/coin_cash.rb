class CoinCash < ApplicationRecord
  belongs_to :user
  belongs_to :coin

  has_one :coin_log, ->(o){ where(user_id: o.user_id) }, as: :source

  after_initialize if: :new_record? do
    self.coin_id = self.user.coin.id
    self.cash_amount = self.coin_amount / 100
  end
  after_create_commit :sync_coin_log

  def sync_coin_log
    cl = self.coin_log || self.build_coin_log
    cl.title = '提现'
    cl.amount = self.coin_amount
    cl.save
  end

end
