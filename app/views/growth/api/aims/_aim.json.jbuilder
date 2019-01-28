json.extract! aim, :id, :name, :task_point, :repeat_type
if current_user
  progress = AimProgress.new(current_user, aim)
  json.progress progress.progress
  json.done progress.done?
end
