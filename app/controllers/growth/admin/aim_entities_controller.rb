module Growth
  class Admin::AimEntitiesController < Admin::BaseController
    before_action :set_aim_entity, only: [:show, :destroy]
    before_action :set_aim, only: [:index]

    def index
      q_params = {}
      q_params.merge! params.permit(:user_id, :ip, :entity_type, :entity_id)

      @aim_entities = @aim.aim_entities.includes(:user).default_where(q_params).order(id: :desc).page(params[:page])
    end

    private
    def set_aim_entity
      @aim_entity = AimEntity.find(params[:id])
    end

    def set_aim
      @aim = Aim.find params[:aim_id]
    end

  end
end
