class Growth::My::AimLogsController < Growth::My::BaseController
  before_action :set_aim_log, only: [:show]

  def show
    render json: @aim_log
  end

  def create
    r = growth_log(params[:code])
    rewardable_codes = []
    unless r.blank?
      rewardable_codes = r[0].entity.rewardable_codes(aim_user.id)
    end
    if r.present?
      @reward_amount = r.select(&:rewarded).sum { |i| i.aim_entity.reward_amount }
    end

    if @reward_amount.to_d > 0
      reward = {
        amount: @reward_amount,
        code: 'success',
        rewardable_codes: rewardable_codes
      }
      render json: { aim_logs: r, reward: reward }, status: :created
    elsif r.present?
      render json: { aim_logs: r }, status: :created
    else
      # todo
      render json: { reward: { amount: 0, code: 'over_limit' } }, status: :ok
    end
  end

  private
  def set_aim_log
    @aim_log = AimLog.find(params[:id])
  end

  def aim_log_params
    params.permit(
      :code
    )
  end
end
