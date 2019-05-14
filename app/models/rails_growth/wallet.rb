module RailsGrowth::Wallet
  extend ActiveSupport::Concern
  included do
    has_many :praise_incomes, primary_key: :user_id, foreign_key: :user_id
    has_many :earned_incomes, class_name: 'PraiseIncome', primary_key: :user_id, foreign_key: :earner_id
  end
  
  def compute_expense_amount
    origin_amount = super

    if RailsGrowth.config.gift_purchase == 'Wallet'
      praise_amount = self.praise_incomes.sum(:amount)
    else
      praise_amount = 0
    end

    origin_amount + praise_amount
  end

  def compute_income_amount
    origin_amount = super

    if RailsGrowth.config.gift_purchase == 'Wallet'
      earned_amount = self.earned_incomes.sum(:royalty_amount)
    else
      earned_amount = 0
    end

    origin_amount + earned_amount
  end

end
