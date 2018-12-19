class AimUser < ApplicationRecord
  attribute :state, :string, default: 'doing'
  belongs_to :aim
  belongs_to :user, optional: true
  has_many :aim_logs, ->(o){ where(user_id: o.user_id, entity_type: o.entity_type, entity_id: o.entity_id) }, foreign_key: :aim_id, primary_key: :aim_id
  belongs_to :entity, polymorphic: true

  enum state: {
    doing: 'doing',
    done: 'done'
  }

  validates :user_id, presence: true, uniqueness: { scope: [:aim_id, :serial_number, :entity_type, :entity_id] }, if: -> { ip.blank? }
  validates :ip, presence: true, uniqueness: { scope: [:aim_id, :serial_number, :entity_type, :entity_id] }, if: -> { user_id.blank? }

end
