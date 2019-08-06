if @praise_user&.persisted?
  json.praise_user @praise_user, partial: 'praise_user', as: :praise_user
end
json.praise_users @praise_users, partial: 'praise_user', as: :praise_user
json.praise_amount @praise_users.sum(:amount)
json.partial! 'api/shared/pagination', items: @praise_users
