module Growth
  module Model::Aim
    extend ActiveSupport::Concern

    included do
      attribute :name, :string
      attribute :unit, :string
      attribute :repeat_type, :string
      attribute :rate, :decimal, precision: 10, scale: 2, default: 1
      attribute :task_point, :integer, default: 0
      attribute :reward_point, :integer, default: 0
      attribute :reward_amount, :integer, default: 0
      attribute :verbose, :boolean

      has_many :aim_codes, dependent: :delete_all
      has_many :aim_users, dependent: :nullify
      has_many :aim_entities, dependent: :nullify
      has_many :aim_logs, dependent: :nullify

      accepts_nested_attributes_for :aim_codes, allow_destroy: true, reject_if: :all_blank

      enum :repeat_type, {
        once: 'once',
        daily: 'daily',
        weekly: 'weekly',
        monthly: 'monthly',
        yearly: 'yearly',
        forever: 'forever'
      }

      scope :reward, -> { default_where('reward_point-gt': 0) }
      scope :task, -> { default_where('task_point-gt': 0) }
    end

    def aim_user(user_id)
      self.aim_users.find { |i| i.user_id == user_id }
    end

    def serial_hash(now = Time.current)
      case repeat_type
      when 'forever'
        now.strftime('%Y%j%H%M%S%L')
      when 'daily'
        { text_date: now.strftime('%Y%j') }
      when 'weekly'
        { text_week: now.strftime('%Y%U') }
      when 'monthly'
        { text_month: now.strftime('%Y%m') }
      when 'yearly'
        { text_year: now.strftime('%Y') }
      else
        now.strftime('%Y%j%H%M%S%L')
      end
    end

    class_methods do

      def reward_codes
        includes(:aim_codes).reward.map { |i| i.aim_codes.pluck(:code) }.flatten
      end

    end

  end
end
