json.coin_cashes @coin_cashes, partial: 'coin_cash', as: :coin_cash
json.partial! 'api/shared/pagination', items: @coin_cashes
