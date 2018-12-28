json.extract! coin_wallet, :id, :coin_amount, :wallet_amount, :created_at
json.coin coin_wallet.coin, :id, :amount, :income_amount, :expense_amount
json.wallet coin_wallet.wallet, :id, :total_balance, :ios_balance, :other_balance
