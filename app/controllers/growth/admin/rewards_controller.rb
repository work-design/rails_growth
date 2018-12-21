class Growth::Admin::RewardsController < Growth::Admin::BaseController
  before_action :set_reward, only: [:show, :edit, :update, :destroy]

  def index
    @rewards = Reward.page(params[:page])
  end

  def new
    @reward = Reward.new
  end

  def create
    @reward = Reward.new(reward_params)

    if @reward.save
      redirect_to admin_rewards_url, notice: 'Reward was successfully created.'
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @reward.update(reward_params)
      redirect_to admin_rewards_url, notice: 'Reward was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @reward.destroy
    redirect_to admin_rewards_url, notice: 'Reward was successfully destroyed.'
  end

  private
  def set_reward
    @reward = Reward.find(params[:id])
  end

  def reward_params
    params.fetch(:reward, {}).permit(
      :amount,
      :entity_type,
      :entity_id,
      :max_piece,
      :min_piece,
      :start_at,
      :finish_at,
      :disabled
    )
  end

end
