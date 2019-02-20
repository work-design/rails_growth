if defined?(@praise_user)
  json.praise_user @praise_user, partial: 'praise_user', as: :praise_user
end
json.praise_users @praise_users, partial: 'praise_user', as: :praise_user
json.partial! 'api/shared/pagination', items: @praise_users
