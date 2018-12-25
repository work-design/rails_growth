json.coin_log @coin_log, partial: 'coin_log', as: :coin_log
json.total_count @coin_log.total_count
json.total_score @coin_log.sum(:score)
json.done_count current_user.coin_log_users.where(state: 'done').count

json.user_coins @user_coins.as_json(include: [:user], only: [:income_amount]) 
