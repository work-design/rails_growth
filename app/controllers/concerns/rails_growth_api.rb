module RailsGrowthApi
  extend ActiveSupport::Concern

  included do
    after_action :growth_record
  end

  def growth_api(code, entity_type, entity_id)
    aim_ids = AimCode.growth_hash[code]
    return if aim_ids.blank?

    Aim.where(id: aim_ids).map do |aim|
      if current_user
        sn = SerialNumberHelper.result(Time.now, aim.repeat_type)
        au = current_user.aim_users.find_by(aim_id: aim.id, serial_number: sn)
        next if au&.done?
        aim_log = current_user.aim_logs.build(aim_id: aim.id)
      else
        next unless aim.verbose
        aim_log = AimLog.new(aim_id: aim.id)
      end

      aim_log.ip = request.remote_ip
      aim_log.entity_type = entity_type
      aim_log.entity_id = entity_id
      aim_log.code = code
      aim_log.save!
      aim_log
    end
  end

  def growth_log(code)
    growth_api(code, params[:entity_type], params[:entity_id])
  end

  def growth_record
    code = [controller_path, action_name].join('#')
    entity_type = controller_name.classify
    entity_id = params.fetch('id', nil)
    r = growth_api(code, entity_type, entity_id)
    growth_response(r) if r
  end

  def growth_response(r)
    reward_amount = r.select(&:rewarded).sum { |i| i.aim_entity.reward_amount }

    # todo remove for test
    if reward_amount >= 0
      body = JSON.parse(self.response_body[0])
      self.response_body = body.merge(reward: reward_amount).to_json
    end
  end

end
