class Growth::Api::GiftsController < Growth::Api::BaseController
  before_action :set_api_gift, only: [:show, :update, :destroy]

  def index
    @api_gifts = Gift.page(params[:page]).per(params[:per])

    render json: @api_gifts
  end

  def show
    render json: @api_gift
  end

  def create
    @api_gift = Gift.new(api_gift_params)

    if @api_gift.save
      render json: @api_gift, status: :created, location: @api_gift
    else
      render json: @api_gift.errors, status: :unprocessable_entity
    end
  end

  def update
    if @api_gift.update(api_gift_params)
      render json: @api_gift
    else
      render json: @api_gift.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @api_gift.destroy
  end

  private
  def set_gift
    @api_gift = Gift.find(params[:id])
  end

  def api_gift_params
    params.require(:gift).permit(:name, :code, :amount, :praise_incomes_count)
  end

end
