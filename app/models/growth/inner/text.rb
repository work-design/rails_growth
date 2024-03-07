module Growth
  module Inner::Text
    extend ActiveSupport::Concern

    included do
      attribute :text_year, :string
      attribute :text_month, :string
      attribute :text_week, :string
      attribute :text_date, :date

      belongs_to :user, class_name: 'Auth::User', optional: true
      belongs_to :aim, optional: true
    end

    def filter_hash
      {
        aim_id: aim_id,
        text_year: text_year
      }
    end

  end
end
