json.praise_income @praise_income, partial: 'praise_income', as: :praise_income
if current_user
  if RailsGrowth.config.gift_purchase == 'Coin'
    json.coin current_user.coin, :id, :amount
  else
    json.wallet current_user.wallet, :id, :amount
  end
end
