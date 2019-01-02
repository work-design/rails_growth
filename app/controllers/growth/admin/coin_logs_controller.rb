class Growth::Admin::CoinLogsController < Growth::Admin::BaseController
  before_action :set_coin_log, only: [:show, :edit, :update, :destroy]

  def index
    q_params = {}.with_indifferent_access
    q_params.merge! params.permit(:user_id)
    @coin_logs = CoinLog.includes(:user).default_where(q_params).page(params[:page])
  end

  def new
    @coin_log = CoinLog.new
  end

  def create
    @coin_log = CoinLog.new(coin_log_params)

    if @coin_log.save
      redirect_to admin_coin_logs_url, notice: 'Coin log was successfully created.'
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @coin_log.update(coin_log_params)
      redirect_to admin_coin_logs_url, notice: 'Coin log was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @coin_log.destroy
    redirect_to admin_coin_logs_url, notice: 'Coin log was successfully destroyed.'
  end

  private
  def set_coin_log
    @coin_log = CoinLog.find(params[:id])
  end

  def coin_log_params
    params.fetch(:coin_log, {}).permit(
      :title,
      :amount,
      :source_type,
      :source_id
    )
  end

end
