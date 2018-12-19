# todo 支持code 来源
module RailsGrowthApi
  extend ActiveSupport::Concern

  included do
    after_action :growth_record
  end

  def growth_api(aim_ids, entity_type, entity_id)
    aims = Aim.where(id: Array(aim_ids))
    aims.each do |aim|
      if current_user
        present_point = current_user.aim_users.find_by(aim_id: aim.id).present_point.to_i
        if aim.task_point.nil? || aim.task_point >= present_point
          aim_log = current_user.aim_logs.build(aim_id: aim.id)
        else
          next
        end
      else
        aim_log = AimLog.new(aim_id: aim.id)
      end

      aim_log.ip = request.remote_ip
      aim_log.entity_type = entity_type
      aim_log.entity_id = entity_id
      aim_log.save
      aim_log
    end
  end

  def growth_log(code)
    aim_ids = AimCode.growth_hash[code]
    return unless aim_ids

    growth_api(aim_ids, params[:entity_type], params[:entity_id])
  end

  def growth_record
    code = [controller_path, action_name].join('#')
    aim_ids = AimCode.growth_hash[code]
    return unless aim_ids

    entity_type = controller_name.classify
    entity_id = params.fetch('id', nil)
    growth_api(aim_ids, entity_type, entity_id)
  end

end
