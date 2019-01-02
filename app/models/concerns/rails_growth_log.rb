module RailsGrowthLog
  extend ActiveSupport::Concern
  included do
    has_one :coin_log, as: :source, primary_key: :user_id, foreign_key: :user_id
    after_create_commit :sync_log
  end



end
