class Growth::Api::CoinLogsController < Growth::Api::BaseController
  before_action :set_api_coin_log, only: [:show, :update, :destroy]

  def index
    @coin_logs = current_user.coin_logs.page(params[:page])

    render json: @coin_logs
  end

  def show
    render json: @api_coin_log
  end

  def create
    @api_coin_log = CoinLog.new(api_coin_log_params)

    if @api_coin_log.save
      render json: @api_coin_log, status: :created, location: @api_coin_log
    else
      render json: @api_coin_log.errors, status: :unprocessable_entity
    end
  end

  def update
    if @api_coin_log.update(api_coin_log_params)
      render json: @api_coin_log
    else
      render json: @api_coin_log.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @api_coin_log.destroy
  end

  private
  def set_api_coin_log
    @api_coin_log = CoinLog.find(params[:id])
  end

  def api_coin_log_params
    params.fetch(:api_coin_log, {})
  end
end
