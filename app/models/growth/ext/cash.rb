module Growth
  module Ext::Cash
    extend ActiveSupport::Concern

    included do
      has_many :reward_expenses, primary_key: :user_id, foreign_key: :user_id
    end

    def compute_income_amount
      origin_amount = super
      reward_amount = self.reward_expenses.sum(:amount)

      origin_amount + reward_amount
    end

  end
end
