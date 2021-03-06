module Growth
  module Controller::Application
    extend ActiveSupport::Concern

    included do
      after_action :growth_record
    end

    def aim_user
      current_user
    end

    def growth_api(code, entity_type, entity_id)
      aim_ids = AimCode.growth_hash[code]
      return if aim_ids.blank?

      Aim.where(id: aim_ids).map do |aim|
        if aim_user
          sn = RailsGrowth::SerialNumberHelper.result(Time.now, aim.repeat_type)
          au = aim_user.aim_users.find_by(aim_id: aim.id, serial_number: sn)
          ae = aim_user.aim_entities.find_by(aim_id: aim.id, serial_number: sn, entity_type: entity_type, entity_id: entity_id)
          next if au&.task_done? && ae
          aim_log = aim_user.aim_logs.build(aim_id: aim.id)
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
      end.compact
    end

    def growth_log(code)
      growth_api(code, params[:entity_type], params[:entity_id])
    end

    def growth_record
      code = [controller_path, action_name].join('#')
      entity_type = growth_entity_type
      entity_id = growth_entity_id
      r = growth_api(code, entity_type, entity_id)
      growth_response(r) if r.present?
    end

    def growth_response(r)
      reward_amount = r.select(&:rewarded).sum { |i| i.aim_entity.reward_amount }
      rewardable_codes = []
      unless r.blank?
        rewardable_codes = r[0].entity.rewardable_codes(aim_user.id)
      end

      if reward_amount > 0
        reward = {
          amount: reward_amount,
          code: 'success',
          rewardable_codes: rewardable_codes
        }
        body = JSON.parse(self.response_body[0])
        self.response_body = body.merge(reward: reward).to_json
      end
    end

    def growth_entity_type
      controller_name.classify
    end

    def growth_entity_id
      params.fetch('id', nil)
    end

  end
end
