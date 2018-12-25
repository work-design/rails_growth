json.user_coins @user_coins, partial: 'user_coin', as: :user_coin
json.partial! 'api/shared/pagination', items: @user_coins
