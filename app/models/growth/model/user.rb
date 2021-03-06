module Growth
  module Model::User
    extend ActiveSupport::Concern

    included do
      has_many :aim_users, dependent: :destroy
      has_many :aim_entities, dependent: :nullify
      has_many :aims, through: :aim_users
      has_many :aim_logs
      has_many :reward_expenses
    end

    def reward_amount
      self.reward_expenses.sum(:amount)
    end

    def xx
    end

  end
end
