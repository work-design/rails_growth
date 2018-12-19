class Growth::Api::BaseController < ApiController
  before_action :require_login_from_token


end
