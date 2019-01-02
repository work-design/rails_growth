class Growth::Admin::RewardExpensesController < Growth::Admin::BaseController
  before_action :set_reward
  before_action :set_reward_expense, only: [:show, :edit, :update, :destroy]

  def index
    @reward_expenses = @reward.reward_expenses.page(params[:page])
  end

  def new
    @reward_expense = @reward.reward_expenses.build
  end

  def create
    @reward_expense = @reward.reward_expenses.build(reward_expense_params)

    if @reward_expense.save
      redirect_to admin_reward_reward_expenses_url(@reward), notice: 'Reward expense was successfully created.'
    else
      render :new
    end
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
      :amount
    )
  end

end
