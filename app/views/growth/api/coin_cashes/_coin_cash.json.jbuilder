json.extract! coin_cash, :id, :coin_amount, :cash_amount, :created_at
json.coin coin_cash.coin, :id, :amount, :expense_amount
