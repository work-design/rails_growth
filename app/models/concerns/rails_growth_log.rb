module RailsGrowthLog
  extend ActiveSupport::Concern
  included do
    has_one :coin_log, as: :source
    after_create_commit :sync_log
  end



end
