class Growth::Admin::AimEntitiesController < Growth::Admin::BaseController
  before_action :set_aim_entity, only: [:show, :destroy]
  before_action :set_aim, only: [:index]

  def index
    q_params = {}.with_indifferent_access
    q_params.merge! params.permit(:user_id, :ip)
    q_params.merge! params.fetch(:q, {}).permit(:ip, :entity_type, :entity_id)
    @aim_entities = @aim.aim_entities.includes(:user).default_where(q_params).page(params[:page])
  end

  def show
  end

  def destroy
    @aim_entity.destroy
    redirect_to admin_aim_aim_entities_url(@aim_entity.aim_id), notice: 'Aim user was successfully destroyed.'
  end

  private
  def set_aim_entity
    @aim_entity = AimEntity.find(params[:id])
  end

  def set_aim
    @aim = Aim.find params[:aim_id]
  end

end
