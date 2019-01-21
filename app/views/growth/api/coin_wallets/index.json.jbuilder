json.array! @coin_wallets, partial: 'coin_wallet', as: :coin_wallet
json.partial! 'api/shared/pagination', items: @coin_wallets
