class Growth::Admin::AimLogsController < Growth::Admin::BaseController
  before_action :set_aim_log, only: [:destroy]

  def index
    @aim_entity = AimEntity.find(params[:aim_entity_id])
    @aim_logs = @aim_entity.aim_logs.order(id: :desc).page(params[:page])
  end

  def destroy
    @aim_log.destroy
    redirect_to admin_aim_user_aim_logs_url(params[:aim_user_id]), notice: 'Aim log was successfully destroyed.'
  end

  private
  def set_aim_log
    @aim_log = AimLog.find(params[:id])
  end

end
