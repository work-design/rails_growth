module Growth
  module Model::Promote
    extend ActiveSupport::Concern

    included do
      has_many :aim_users, primary_key: :user_id, foreign_key: :user_id
      has_many :reward_expenses, primary_key: :user_id, foreign_key: :user_id
      has_many :praise_incomes, primary_key: :user_id, foreign_key: :user_id
      has_many :earned_incomes, class_name: 'PraiseIncome', primary_key: :user_id, foreign_key: :earner_id
    end

    def compute_income_amount
      origin_amount = super
      aim_amount = self.aim_users.sum(:reward_amount)

      earned_amount = self.earned_incomes.sum(:royalty_amount)
      reward_amount = self.reward_expenses.sum(:amount)

      origin_amount + aim_amount + earned_amount + reward_amount
    end

    def compute_expense_amount
      origin_amount = super
      praise_amount = self.praise_incomes.sum(:amount)

      origin_amount + praise_amount
    end

  end
end
