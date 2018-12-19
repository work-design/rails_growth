class Growth::Admin::AimUsersController < Growth::Admin::BaseController
  before_action :set_aim_user, only: [:show, :edit, :update, :destroy]
  before_action :set_aim, only: [:index]

  def index
    q_params = {}.with_indifferent_access
    q_params.merge! params.permit(:user_id)
    q_params.merge! params.fetch(:q, {}).permit(:ip, :entity_type, :entity_id)
    @aim_users = @aim.aim_users.default_where(q_params).page(params[:page])
  end

  def new
    @aim_user = AimUser.new
  end

  def create
    @aim_user = AimUser.new(aim_user_params)

    if @aim_user.save
      redirect_to admin_aim_users_url, notice: 'Aim user was successfully created.'
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @aim_user.update(aim_user_params)
      redirect_to admin_aim_users_url, notice: 'Aim user was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @aim_user.destroy
    redirect_to admin_aim_aim_users_url(@aim_user.aim_id), notice: 'Aim user was successfully destroyed.'
  end

  private
  def set_aim_user
    @aim_user = AimUser.find(params[:id])
  end

  def set_aim
    @aim = Aim.find params[:aim_id]
  end

  def aim_user_params
    params.fetch(:aim_user, {}).permit(
      :user,
      :present_point,
      :serial_number
    )
  end

end
