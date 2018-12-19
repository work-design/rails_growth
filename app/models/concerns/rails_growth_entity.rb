module RailsGrowthEntity
  extend ActiveSupport::Concern
  included do
    has_one :reward, as: :entity
  end



end
