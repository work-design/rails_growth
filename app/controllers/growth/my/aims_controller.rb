class Growth::Api::AimsController < Growth::Api::BaseController
  before_action :set_aim, only: [:show, :update, :destroy]

  def index
    @aims = Aim.page(params[:page]).per(params[:per])
  end

  def create
    @aim = Aim.new(aim_params)

    if @aim.save
      render json: @aim, status: :created, location: @aim
    else
      render json: @aim.errors, status: :unprocessable_entity
    end
  end

  def show
    render json: @aim.as_json(root: true)
  end

  def update
    if @aim.update(aim_params)
      render json: @aim
    else
      render json: @aim.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @aim.destroy
  end

  private
  def set_aim
    @aim = Aim.find(params[:id])
  end

  def aim_params
    params.fetch(:aim, {})
  end
end
