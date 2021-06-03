class My::GiftsController < My::BaseController
  before_action :set_gift, only: [:give]
  before_action :require_login, only: [:give]

  def index
    @gifts = Gift.order(praise_incomes_count: :desc).page(params[:page]).per(params[:per])
  end

  def give
    @reward = Reward.find_or_create_by!(entity_type: params[:entity_type], entity_id: params[:entity_id])
    @praise_income = @gift.give_to(@reward, current_user)

    if @praise_income.persisted?
      render 'give'
    else
      process_errors(@praise_income)
    end
  end

  private
  def set_gift
    @gift = Gift.find(params[:id])
  end

end
