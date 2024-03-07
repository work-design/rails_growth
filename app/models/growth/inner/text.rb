module Growth
  module Inner::Text
    extend ActiveSupport::Concern

    included do
      attribute :text_year, :string
      attribute :text_month, :string
      attribute :text_week, :string
      attribute :text_date, :string

      belongs_to :user, class_name: 'Auth::User', optional: true
      belongs_to :aim, optional: true
    end

    def filter_hash
      {
        aim_id: aim_id,
        text_year: text_year,
        text_month: text_month,
        text_week: text_week,
        text_date: text_date
      }
    end

    def origin_date
      text_date.to_date
    end

  end
end
