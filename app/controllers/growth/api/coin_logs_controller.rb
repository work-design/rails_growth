class Growth::Api::CoinLogsController < Growth::Api::BaseController
  skip_before_action :require_login, only: [:top]

  def index
    @coin_logs = current_user.coin_logs.page(params[:page])
    @coin = current_user.coin
  end

  def top
    @coins = Coin.order(amount: :desc).page(params[:page])
    if current_user
      @coin = current_user.coin
    end
  end

end
