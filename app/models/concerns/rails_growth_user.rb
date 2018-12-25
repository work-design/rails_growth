module RailsGrowthUser
  extend ActiveSupport::Concern
  included do
    has_one :user_coin

    has_many :aim_users, dependent: :destroy
    has_many :aim_entities, dependent: :nullify
    has_many :aims, through: :aim_users
    has_many :aim_logs
    has_many :reward_expenses
    has_many :coin_logs
  end

  def reward_amount
    self.reward_expenses.sum(:amount)
  end

  def user_coin
    super ? super : create_user_coin
  end

end
