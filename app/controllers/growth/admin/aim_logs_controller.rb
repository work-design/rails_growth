class Growth::Admin::AimLogsController < Growth::Admin::BaseController
  before_action :set_aim_log, only: [:show, :edit, :update, :destroy]

  def index
    @aim_user = AimUser.find(params[:aim_user_id])
    @aim_logs = @aim_user.aim_logs.page(params[:page])
  end

  def new
    @aim_log = AimLog.new
  end

  def create
    @aim_log = AimLog.new(aim_log_params)

    if @aim_log.save
      redirect_to admin_aim_logs_url, notice: 'Aim log was successfully created.'
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @aim_log.update(aim_log_params)
      redirect_to admin_aim_logs_url, notice: 'Aim log was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @aim_log.destroy
    redirect_to admin_aim_user_aim_logs_url(params[:aim_user_id]), notice: 'Aim log was successfully destroyed.'
  end

  private
  def set_aim_log
    @aim_log = AimLog.find(params[:id])
  end

  def aim_log_params
    params.fetch(:aim_log, {}).permit(
      :created_at,
    )
  end

end
