class Growth::Admin::RewardExpensesController < Growth::Admin::BaseController
  before_action :set_reward_expense, only: [:show, :edit, :update, :destroy]

  def index
    q_params = {}.with_indifferent_access
    q_params.merge! params.permit(:reward_id, :user_id)
    @reward_expenses = RewardExpense.default_where(q_params).page(params[:page])
  end

  def new
    @reward = Reward.find params[:reward_id]
    @reward_expense = @reward.reward_expenses.build
  end

  def create
    @reward_expense = RewardExpense.new(reward_expense_params)

    if @reward_expense.save
      redirect_to admin_reward_expenses_url(reward_id: @reward_expense.reward_id), notice: 'Reward expense was successfully created.'
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
