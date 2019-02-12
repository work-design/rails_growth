class AimUser < ApplicationRecord
  attribute :state, :string, default: 'task_doing'

  belongs_to :aim, optional: true
  belongs_to :user, optional: true
  has_many :aim_entities, ->(o){ where(user_id: o.user_id) }, foreign_key: :aim_id, primary_key: :aim_id

  enum state: {
    task_doing: 'task_doing',
    task_done: 'task_done'
  }

  def progress
    [aim_entities_count.to_i, aim.task_point]
  end

end
