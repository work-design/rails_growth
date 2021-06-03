module Growth
  class Admin::RewardIncomesController < Admin::BaseController
    before_action :set_reward, only: [:index, :new, :create]
    before_action :set_reward_income, only: [:show, :edit, :update, :destroy]

    def index
      @reward_incomes = @reward.reward_incomes.page(params[:page])
    end

    def new
      @reward_income = @reward.reward_incomes.build
    end

    def create
      @reward_income = @reward.reward_incomes.build(reward_income_params)

      if @reward_income.save
        render 'create'
      else
        render :new
      end
    end

    def show
    end

    def edit
    end

    def update
      if @reward_income.update(reward_income_params)
        render 'update'
      else
        render :edit
      end
    end

    def destroy
      @reward_income.destroy
    end

    private
    def set_reward
      @reward = Reward.find(params[:reward_id])
    end

    def set_reward_income
      @reward_income = RewardIncome.find(params[:id])
    end

    def reward_income_params
      q = params.fetch(:reward_income, {}).permit(
        :reward_amount
      )
      q.merge(user_id: current_user.id)
    end

  end
end
