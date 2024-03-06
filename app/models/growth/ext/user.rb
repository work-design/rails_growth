module Growth
  module Ext::User
    extend ActiveSupport::Concern

    included do
      has_many :aim_users, class_name: 'Growth::AimUser', dependent: :destroy
      has_many :aim_entities, class_name: 'Growth::AimEntity', dependent: :nullify
      has_many :aim_logs, class_name: 'Growth::AimLog'
      has_many :reward_expenses, class_name: 'Growth::RewardExpense'

      has_many :aims, class_name: 'Growth::Aim', through: :aim_users
    end

    def reward_amount
      self.reward_expenses.sum(:amount)
    end

    def xx
    end

  end
end
