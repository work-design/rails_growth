class Growth::My::AimUsersController < Growth::My::BaseController
  before_action :set_aim_user, only: [:show]

  def index
    @aim_users = AimUser.page(params[:page]).per(params[:per])

    render json: { aim_users: @aim_users }
  end

  def show
    render json: @aim_user
  end

  private
  def set_aim_user
    @aim_user = AimUser.find(params[:id])
  end

  def aim_user_params
    params.fetch(:aim_user, {})
  end
end
