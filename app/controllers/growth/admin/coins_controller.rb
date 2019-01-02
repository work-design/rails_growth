class Growth::Admin::CoinsController < Growth::Admin::BaseController
  before_action :set_coin, only: [:show, :edit, :update, :destroy]

  def index
    @coins = Coin.includes(:user).page(params[:page])
  end

  def new
    @coin = Coin.new
  end

  def create
    @coin = Coin.new(coin_params)

    if @coin.save
      redirect_to admin_coins_url, notice: 'Coin was successfully created.'
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @coin.update(coin_params)
      redirect_to admin_coins_url, notice: 'Coin was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @coin.destroy
    redirect_to admin_coins_url, notice: 'Coin was successfully destroyed.'
  end

  private
  def set_coin
    @coin = Coin.find(params[:id])
  end

  def coin_params
    params.fetch(:coin, {}).permit(
      :amount,
      :income_amount,
      :expense_amount,
      :position
    )
  end

end
