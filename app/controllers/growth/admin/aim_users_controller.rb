class Growth::Admin::AimUsersController < Growth::Admin::BaseController
  before_action :set_aim, only: [:index]
  before_action :set_aim_user, only: [:show, :edit, :update, :destroy]

  def index
    @aim_users = @aim.aim_users.page(params[:page])
  end

  def show
  end

  def edit
  end

  def update
    if @aim_user.update(aim_user_params)
      redirect_to admin_aim_users_url, notice: 'Aim statistic was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @aim_user.destroy
    redirect_to admin_aim_users_url, notice: 'Aim statistic was successfully destroyed.'
  end

  private
  def set_aim
    @aim = Aim.find(params[:aim_id])
  end

  def set_aim_user
    @aim_user = AimUser.find(params[:id])
  end

  def aim_user_params
    params.fetch(:aim_user, {}).permit(
      :user,
      :ip,
      :serial_number,
      :state,
      :aim_users_count
    )
  end

end
