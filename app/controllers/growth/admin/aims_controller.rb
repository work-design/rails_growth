class Growth::Admin::AimsController < Growth::Admin::BaseController
  before_action :set_aim, only: [:show, :edit, :update, :destroy]

  def index
    @aims = Aim.includes(:aim_codes).page(params[:page])
  end

  def new
    @aim = Aim.new
    @aim.aim_codes.build
  end

  def create
    @aim = Aim.new(aim_params)

    if @aim.save
      redirect_to admin_aims_url, notice: 'Aim was successfully created.'
    else
      render :new
    end
  end

  def show
  end

  def edit
    if @aim.aim_codes.count == 0
      @aim.aim_codes.build
    end
  end

  def update
    if @aim.update(aim_params)
      redirect_to admin_aims_url, notice: 'Aim was successfully updated.'
    else
      render :edit
    end
  end

  def add_item
    @aim = Aim.new
    @aim.aim_codes.build
  end

  def remove_item

  end

  def destroy
    @aim.destroy
    redirect_to admin_aims_url, notice: 'Aim was successfully destroyed.'
  end

  private
  def set_aim
    @aim = Aim.find(params[:id])
  end

  def aim_params
    params.fetch(:aim, {}).permit(
      :name,
      :task_point,
      :reward_point,
      :unit,
      :score,
      :repeat_type,
      :params,
      aim_codes_attributes: {}
    )
  end

end
