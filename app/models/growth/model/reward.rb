module Growth
  module Model::Reward
    extend ActiveSupport::Concern

    included do
      attribute :min_piece, :decimal, precision: 10, scale: 2, default: RailsGrowth.config.default_min_piece
      attribute :max_piece, :decimal, precision: 10, scale: 2, default: RailsGrowth.config.default_max_piece
      attribute :amount, :decimal, precision: 10, scale: 2
      attribute :income_amount, :decimal, precision: 10, scale: 2
      attribute :expense_amount, :decimal, precision: 10, scale: 2
      attribute :start_at, :datetime
      attribute :finish_at, :datetime
      attribute :enabled, :boolean, default: true
      attribute :lock_version, :integer

      belongs_to :entity, polymorphic: true
      has_many :reward_incomes, dependent: :destroy
      has_many :praise_incomes, dependent: :destroy
      has_many :reward_expenses, dependent: :destroy
      has_many :aim_users, ->(o){ where(entity_type: o.entity_type) }, primary_key: :entity_id, foreign_key: :entity_id
      has_many :praise_users, dependent: :destroy

      validates :max_piece, numericality: { greater_than_or_equal_to: -> (o) { o.min_piece } }, allow_blank: true
      validates :min_piece, numericality: { less_than_or_equal_to: -> (o) { o.max_piece } }, allow_blank: true
      validates :amount, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true
    end

    def compute_expense_amount
      self.reward_expenses.sum(:amount)
    end

    def compute_income_amount
      inhouse = self.reward_incomes.sum(:reward_amount)
      praise = self.praise_incomes.sum(:reward_amount)

      inhouse + praise
    end

    def available?
      enabled? &&
      amount > 0
    end

    def per_piece
      if self.amount > 0
        r = self.max_piece - 1 / (self.amount + 1/(self.max_piece - min_piece))
      else
        r = 0
      end
      pad = (max_piece - r)

      rand((r - pad)..(r + pad)).round(2)
    end

    def save_with_amount(amount = 0)
      self.reward_incomes.build(reward_amount: amount) if amount > 0
      self.save
    end

    class_methods do
      def entity_types
        self.distinct(:entity_type).pluck(:entity_type)
      end
    end

  end
end
