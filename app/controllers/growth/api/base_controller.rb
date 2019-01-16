class Growth::Api::BaseController < RailsGrowth.config.api_class.constantize
  before_action :require_login


end
