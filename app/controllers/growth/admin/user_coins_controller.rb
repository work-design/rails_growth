class Growth::Admin::UserCoinsController < Growth::Admin::BaseController
  before_action :set_user_coin, only: [:show, :edit, :update, :destroy]

  def index
    @user_coins = UserCoin.page(params[:page])
  end

  def new
    @user_coin = UserCoin.new
  end

  def create
    @user_coin = UserCoin.new(user_coin_params)

    if @user_coin.save
      redirect_to admin_user_coins_url, notice: 'User coin was successfully created.'
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @user_coin.update(user_coin_params)
      redirect_to admin_user_coins_url, notice: 'User coin was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @user_coin.destroy
    redirect_to admin_user_coins_url, notice: 'User coin was successfully destroyed.'
  end

  private
  def set_user_coin
    @user_coin = UserCoin.find(params[:id])
  end

  def user_coin_params
    params.fetch(:user_coin, {}).permit(
      :amount,
      :income_amount,
      :expense_amount,
      :user,
    )
  end

end
