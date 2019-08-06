json.extract! aim, :id, :name, :task_point, :repeat_type
if current_user
  aim_user = AimUser.find_by(user_id: current_user, aim_id: aim.id)
  json.progress aim_user&.progress || [0, aim.task_point]
  json.done aim_user&.task_done? || false
end
