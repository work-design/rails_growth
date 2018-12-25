class Growth::Api::CoinLogsController < Growth::Api::BaseController
  skip_before_action :require_login_from_token, only: [:top]

  def index
    @coin_logs = current_user.coin_logs.page(params[:page])
    @user_coin = current_user.user_coin || current_user.create_user_coin

    render json: {
      user_coin: @user_coin.as_json(only: [:amount, :income_amount, :expense_amount]),
      coin_logs: @coin_logs.as_json(only: [:title, :amount, :created_at])
    }
  end

  def top
    @user_coins = UserCoin.order(amount: :desc).page(params[:page])
  end


end
