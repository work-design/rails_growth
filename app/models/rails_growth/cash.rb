module RailsGrowth::Cash
  extend ActiveSupport::Concern
  included do
    has_many :reward_expenses, primary_key: :user_id, foreign_key: :user_id
  end
  
  def compute_income_amount
    origin_amount = super

    if RailsGrowth.config.reward_purchase == 'Cash'
      reward_amount = self.reward_expenses.sum(:amount)
    else
      reward_amount = 0
    end

    origin_amount + reward_amount
  end

end
