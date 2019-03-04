class PraiseUser < ApplicationRecord
  acts_as_list scope: [:entity_type, :entity_id]
  attribute :amount, :decimal, default: 0

  belongs_to :user
  belongs_to :reward
  has_many :praise_incomes, ->(o){ where(reward_id: o.reward_id) }, foreign_key: :user_id, primary_key: :user_id

  after_initialize if: :new_record? do
    self.entity_type = reward.entity_type
    self.entity_id = reward.entity_id
  end

  def compute_amount
    self.praise_incomes.sum(:amount)
  end

  def self.reset_position
    self.select(:entity_type, :entity_id).distinct.each do |pu|
      self.where(entity_type: pu.entity_type, entity_id: pu.entity_id).order(amount: :desc).each.with_index(1) do |item, index|
        item.update_column :position, index
      end
    end
  end

end
