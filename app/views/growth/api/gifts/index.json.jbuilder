json.gifts @gifts, partial: 'gift', as: :gift
json.total_count @gifts.total_count
if RailsGrowth.config.gift_purchase == 'Coin'
  json.coin current_user.coin, :id, :amount
else
  json.wallet current_user.wallet, :id, :amount
end
