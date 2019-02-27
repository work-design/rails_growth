class InhouseIncome < RewardIncome
  before_save :split_amount, if: -> { amount_changed? }

  def split_amount
    self.reward_amount = amount
    self.royalty_amount = 0
    self.profit_amount = self.amount - reward_amount - royalty_amount
  end
end
