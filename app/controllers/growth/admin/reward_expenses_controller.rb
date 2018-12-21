class Growth::Admin::RewardExpensesController < Growth::Admin::BaseController
  before_action :set_reward
  before_action :set_reward_expense, only: [:show, :edit, :update, :destroy]

  def index
    @reward_expenses = @reward.reward_expenses.page(params[:page])
  end

  def show
  end

  def edit
  end

  def update
    if @reward_expense.update(reward_expense_params)
      redirect_to admin_reward_expenses_url, notice: 'Reward expense was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @reward_expense.destroy
    redirect_to admin_reward_reward_expenses_url(@reward), notice: 'Reward expense was successfully destroyed.'
  end

  private
  def set_reward
    @reward = Reward.find(params[:reward_id])
  end

  def set_reward_expense
    @reward_expense = RewardExpense.find(params[:id])
  end

  def reward_expense_params
    params.fetch(:reward_expense, {}).permit(
      :amount,
      :aim,
      :aim_entity,
      :user
    )
  end

end
