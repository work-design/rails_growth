module RailsGrowth::AimCode
  extend ActiveSupport::Concern
  included do
    belongs_to :aim
  
    validates :code, uniqueness: { scope: :aim_id }, presence: true
    before_validation :sync_code
    after_commit :delete_cache
  end
  
  def sync_code
    if self.controller_path.present? && self.action_name.present?
      self.code = [self.controller_path, self.action_name].join('#')
    end
  end

  def delete_cache
    if Rails.cache.delete('rails_growth')
      logger.debug "-----> Cache key rails_growth deleted"
    end
  end
  
  class_methods do
    
    def growth_hash
      Rails.cache.fetch('rails_growth', {}) do
        AimCode.pluck(:code, :aim_id).to_array_h.to_combine_h
      end
    end
    
  end

end
