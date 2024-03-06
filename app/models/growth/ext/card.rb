module Growth
  module Ext::Card
    extend ActiveSupport::Concern

    included do
      has_many :praise_incomes, primary_key: :user_id, foreign_key: :user_id
      has_many :earned_incomes, class_name: 'PraiseIncome', primary_key: :user_id, foreign_key: :earner_id
    end

    def compute_expense_amount
      origin_amount = super
      praise_amount = self.praise_incomes.sum(:amount)

      origin_amount + praise_amount
    end

    def compute_income_amount
      origin_amount = super
      earned_amount = self.earned_incomes.sum(:royalty_amount)

      origin_amount + earned_amount
    end

  end
end
