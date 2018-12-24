module RailsGrowthLog
  extend ActiveSupport::Concern
  included do
    has_one :coin_log, as: :source
    after_commit :sync_log, on: [:update, :create]
  end



end
