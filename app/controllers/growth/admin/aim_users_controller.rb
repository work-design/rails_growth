module Growth
  class Admin::AimUsersController < Admin::BaseController
    before_action :set_aim, only: [:index]
    before_action :set_aim_user, only: [:show, :destroy]

    def index
      q_params = {}
      q_params.merge! params.permit(:ip, :user_id)

      @aim_users = @aim.aim_users.includes(:user).default_where(q_params).order(id: :desc).page(params[:page])
    end

    private
    def set_aim
      @aim = Aim.find(params[:aim_id])
    end

    def set_aim_user
      @aim_user = AimUser.find(params[:id])
    end

  end
end
