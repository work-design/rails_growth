class Growth::Api::GiftsController < Growth::Api::BaseController
  before_action :set_gift, only: [:give]
  before_action :require_login, only: [:give]

  def index
    @api_gifts = Gift.page(params[:page]).per(params[:per])

    render json: @api_gifts
  end

  def give
    @reward = Reward.find_or_create_by(entity_type: params[:entity_type], entity_id: params[:entity_id])
    @reward

    if @gift.give_to(@reward, current_user)
      render json: @gift
    else
      render json: @gift.errors, status: :unprocessable_entity
    end
  end

  private
  def set_gift
    @gift = Gift.find(params[:id])
  end

end
