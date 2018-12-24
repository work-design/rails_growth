json.id aim.id
json.name aim.name
json.wanted_point aim.wanted_point
if current_user
  json.present_point aim.aim_user(current_user.id)&.present_point.to_i
end
json.created_at aim.created_at
json.updated_at aim.updated_at
json.repeat_type aim.repeat_type
