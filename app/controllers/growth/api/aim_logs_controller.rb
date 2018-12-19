class Growth::Api::AimLogsController < Growth::Api::BaseController
  before_action :set_aim_log, only: [:show]

  def show
    render json: @aim_log
  end

  def create
    r = growth_log(params[:code])

    if r
      render json: { aim_log: r }, status: :created
    else
      render json: { message: 'wrong' }, status: :unprocessable_entity
    end
  end

  private
  def set_aim_log
    @aim_log = AimLog.find(params[:id])
  end

  def aim_log_params
    params.permit(
      :code
    )
  end
end
