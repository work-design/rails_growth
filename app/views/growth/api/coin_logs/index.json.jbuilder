json.user_coin @user_coin, :income_amount, :amount, :expense_amount, :today_amount
json.coin_logs @coin_logs, partial: 'coin_log', as: :coin_log
json.partial! 'api/shared/pagination', items: @coin_logs
