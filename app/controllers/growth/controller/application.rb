module Growth
  module Controller::Application
    extend ActiveSupport::Concern

    included do
      after_action :growth_record
    end

    def growth_api(code, entity = nil)
      aim_ids = AimCode.growth_hash[code]
      return if aim_ids.blank?

      Aim.where(id: aim_ids).map do |aim|
        if current_user
          sn = RailsGrowth::SerialNumberHelper.result(Time.current, aim.repeat_type)
          au = current_user.aim_users.find_by(aim_id: aim.id, serial_number: sn)
          aim_entity = current_user.aim_entities.find_by(aim_id: aim.id, serial_number: sn)
          aim_entity.entity = entity
          next if au&.task_done? && aim_entity
          aim_log = aim_entity.aim_logs.build(aim_id: aim.id)
        else
          next unless aim.verbose
          aim_log = AimLog.new(aim_id: aim.id)
        end

        aim_log.ip = request.remote_ip
        aim_log.code = code
        aim_log.save!
        aim_log
      end.compact
    end

    def growth_log(code)
      growth_api(code, entity)
    end

    def growth_record
      r = growth_api([controller_path, action_name].join('#'))
      #growth_response(r) if r.present?
    end

    def growth_response(r)
      reward_amount = r.select(&:rewarded).sum { |i| i.aim_entity.reward_amount }
      rewardable_codes = []
      unless r.blank?
        rewardable_codes = r[0].entity.rewardable_codes(current_user.id)
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

  end
end
