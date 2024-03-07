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
          aim_user = current_user.aim_users.find_or_create_by(aim_id: aim.id, **aim.serial_hash)
          if !aim_user.task_done? && entity
            aim_entity = aim_user.aim_entities.find_or_initialize_by(entity_type: entity.class, entity_id: entity.try(:id))
            aim_entity.aim_logs.build(aim_id: aim.id)
            aim_entity.save
          end
        end
      end
    end

    def growth_record
      growth_api([controller_path, action_name].join('#'))
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
