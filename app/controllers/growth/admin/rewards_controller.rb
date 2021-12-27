module Growth
  class Admin::RewardsController < Admin::BaseController
    before_action :set_reward, only: [:show, :edit, :update, :destroy]

    def index
      q_params = {}
      q_params.merge! params.permit(:entity_type, :entity_id)

      @rewards = Reward.default_where(q_params).order(id: :desc).page(params[:page])
    end

    def new
      @reward = Reward.new
    end

    def create
      @reward = Reward.new(reward_params)

      if @reward.save
        render 'create'
      else
        render :new, locals: { model: @reward }, status: :unprocessable_entity
      end
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
        :enabled
      )
    end

  end
end
