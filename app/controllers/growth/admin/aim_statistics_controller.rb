class Growth::Admin::AimStatisticsController < Growth::Admin::BaseController
  before_action :set_aim, only: [:index]
  before_action :set_aim_statistic, only: [:show, :edit, :update, :destroy]

  def index
    @aim_statistics = @aim.aim_statistics.page(params[:page])
  end

  def show
  end

  def edit
  end

  def update
    if @aim_statistic.update(aim_statistic_params)
      redirect_to admin_aim_statistics_url, notice: 'Aim statistic was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @aim_statistic.destroy
    redirect_to admin_aim_statistics_url, notice: 'Aim statistic was successfully destroyed.'
  end

  private
  def set_aim
    @aim = Aim.find(params[:aim_id])
  end

  def set_aim_statistic
    @aim_statistic = AimStatistic.find(params[:id])
  end

  def aim_statistic_params
    params.fetch(:aim_statistic, {}).permit(
      :user,
      :ip,
      :serial_number,
      :state,
      :aim_users_count
    )
  end

end
