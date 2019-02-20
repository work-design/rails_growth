class Growth::Api::RewardsController < Growth::Api::BaseController
  before_action :set_reward, only: [:top]

  def top
    @praise_users = @reward.praise_users.includes(:user).order(amount: :desc).page(params[:page])

    if current_user
      @praise_user = @praise_users.where(user_id: current_user.id)
    end
  end

  private
  def set_reward
    if params[:id]
      @reward = Reward.find params[:id]
    elsif params[:entity_type] && params[:entity_id]
      @reward = Reward.find_by!(entity_type: params[:entity_type], entity_id: params[:entity_id])
    end
  end

end
