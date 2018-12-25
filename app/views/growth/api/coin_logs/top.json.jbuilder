if current_user
  json.user_coin @user_coin, partial: 'user_coin', as: :user_coin
end
json.user_coins @user_coins, partial: 'user_coin', as: :user_coin
json.partial! 'api/shared/pagination', items: @user_coins
