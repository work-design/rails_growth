class Growth::Api::CoinWalletsController < Growth::Api::BaseController

  def index

  end

  def list
    @coin_wallets = [6, 68, 88, 108, 228, 388].map { |i| { wallet_amount: i, coin_amount: i * 100 } }
  end

  def create
    @coin_wallet = current_user.coin_wallets.build(coin_wallet_params)

    if @coin_wallet.save
      render 'show', status: :created
    else
      process_errrors(@coin_wallet)
    end
  end

  private

  def coin_wallet_params
    params.fetch(:coin_wallet, {}).permit(
      :coin_amount,
      :wallet_amount
    )
  end

end
