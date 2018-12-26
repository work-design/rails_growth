if current_user
  json.coin @coin, partial: 'coin', as: :coin
end
json.coins @coins, partial: 'coin', as: :coin
json.partial! 'api/shared/pagination', items: @coins
