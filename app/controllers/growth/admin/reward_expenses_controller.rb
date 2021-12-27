module Growth
  class Admin::RewardExpensesController < Admin::BaseController
    before_action :set_reward_expense, only: [:show, :edit, :update, :destroy]

    def index
      q_params = {}
      q_params.merge! params.permit(:reward_id, :user_id)

      @reward_expenses = RewardExpense.includes(:user).default_where(q_params).page(params[:page])
    end

    def new
      @reward = Reward.find params[:reward_id]
      @reward_expense = @reward.reward_expenses.build
    end

    def create
      @reward_expense = RewardExpense.new(reward_expense_params)

      if @reward_expense.save
        render 'create'
      else
        render :new, locals: { model: @reward_expense }, status: :unprocessable_entity
      end
    end

    private
    def set_reward_expense
      @reward_expense = RewardExpense.find(params[:id])
    end

    def reward_expense_params
      q = params.fetch(:reward_expense, {}).permit(
        :amount,
        :reward_id,
        :user_id
      )
      q.merge! user_id: current_user.id if q[:user_id].blank?
      q
    end

  end
end
