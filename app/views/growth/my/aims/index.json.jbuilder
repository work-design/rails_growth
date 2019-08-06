json.aims @aims, partial: 'aim', as: :aim
json.total_count @aims.total_count
json.done_count current_user.aim_users.where(state: 'done').count
