class CoinCash < CoinExchange
  alias_attribute :cash_amount, :amount

  validates :coin_amount, numericality: { greater_than_or_equal_to: 1 }

  after_initialize if: :new_record? do
    self.amount = self.coin_amount / 100
  end

  def comment
    '微信提现'
  end

  def sync_coin_log
    cl = self.coin_log || self.build_coin_log
    cl.user_id = self.user_id
    cl.title = '提现'
    cl.tag_str = '兑换支出'
    cl.amount = -self.coin_amount
    cl.save
  end

end
