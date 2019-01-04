class Growth::Admin::CoinExchangesController < Growth::Admin::BaseController
  before_action :set_coin_exchange, only: [:show, :edit, :update, :destroy]

  def index
    q_params = {}.with_indifferent_access
    q_params.merge! params.permit(:user_id, :type)
    @coin_exchanges = CoinExchange.includes(:user).default_where(q_params).page(params[:page])
  end

  def new
    @coin_exchange = CoinExchange.new
  end

  def create
    @coin_exchange = CoinExchange.new(coin_exchange_params)

    if @coin_exchange.save
      redirect_to admin_coin_exchanges_url, notice: 'Coin exchange was successfully created.'
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @coin_exchange.update(coin_exchange_params)
      redirect_to admin_coin_exchanges_url, notice: 'Coin exchange was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @coin_exchange.destroy
    redirect_to admin_coin_exchanges_url, notice: 'Coin exchange was successfully destroyed.'
  end

  private
  def set_coin_exchange
    @coin_exchange = CoinExchange.find(params[:id])
  end

  def coin_exchange_params
    params.fetch(:coin_exchange, {}).permit(
      :type,
      :coin_amount,
      :amount,
      :user_id,
      :state,
      :done_at
    )
  end

end
