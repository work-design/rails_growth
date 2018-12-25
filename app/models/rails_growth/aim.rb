class Aim < ApplicationRecord
  attribute :verbose, :boolean
  has_many :aim_codes, dependent: :delete_all
  has_many :aim_users, dependent: :nullify
  has_many :aim_entities, dependent: :nullify
  has_many :aim_logs, dependent: :nullify

  accepts_nested_attributes_for :aim_codes, allow_destroy: true, reject_if: :all_blank

  enum repeat_type: {
    once: 'once',
    daily: 'daily',
    weekly: 'weekly',
    monthly: 'monthly',
    yearly: 'yearly',
    forever: 'forever'
  }

  def aim_user(user_id)
    self.aim_users.find { |i| i.user_id == user_id }
  end

  def serial_number(timestamp)
    SerialNumberHelper.result(timestamp, repeat_type)
  end

end
