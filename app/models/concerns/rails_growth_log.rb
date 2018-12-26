module RailsGrowthLog
  extend ActiveSupport::Concern
  included do
    has_one :coin_log, ->(o){ where(user_id: o.user_id) }, as: :source
    after_create_commit :sync_log
  end



end
