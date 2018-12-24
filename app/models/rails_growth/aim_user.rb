class AimUser < ApplicationRecord
  attribute :state, :string, default: 'doing'

  belongs_to :aim, optional: true
  belongs_to :user, optional: true
  has_many :aim_entities, ->(o){ where(user_id: o.user_id) }, foreign_key: :aim_id, primary_key: :aim_id

  enum state: {
    doing: 'doing',
    done: 'done'
  }

end
