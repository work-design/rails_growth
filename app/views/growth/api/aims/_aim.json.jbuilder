json.extract! aim, :id, :name, :task_point, :repeat_type
if current_user
  json.aim_entities_count aim.aim_user(current_user.id)&.aim_entities_count.to_i
end
