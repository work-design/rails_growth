class AimProgress
  def initialize(user, aim)
    @user = user
    @aim = aim
  end

  def aim_user
    return @aim_user if defined?(@aim_user)

    sn = SerialNumberHelper.result(Time.now, @aim.repeat_type)
    @aim_user = AimUser.where(aim: @aim, user: @user, serial_number: sn).first
    @aim_user
  end

  def progress
    aim_entities_count = aim_user ? aim_user.aim_entities_count.to_i : 0
    task_point = @aim.task_point
    [aim_entities_count, task_point]
  end

  def done?
    return false unless aim_user
    aim_user.task_done?
  end
end
