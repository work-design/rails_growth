class Growth::Api::CoinCashesController < Growth::Api::BaseController

  def index
    @coin_cashes = current_user.coin_cashes.page(params[:page])
  end

  def list
    @coin = current_user.coin
    @coin_cashes = [6, 68, 88, 108, 228, 388].map { |i| { cash_amount: i, coin_amount: i * 100 } }
  end

  def create
    @coin_cash = current_user.coin_cashes.build(coin_cash_params)

    if @coin_cash.save
      render 'show', status: :created
    else
      process_errors(@coin_cash)
    end
  end

  private
  def coin_cash_params
    params.fetch(:coin_cash, {}).permit(
      :cash_amount,
      :coin_amount
    )
  end
end
