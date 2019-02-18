class Growth::Admin::GiftsController < Growth::Admin::BaseController
  before_action :set_gift, only: [:show, :edit, :update, :destroy]

  def index
    @gifts = Gift.page(params[:page])
  end

  def new
    @gift = Gift.new
  end

  def create
    @gift = Gift.new(gift_params)

    if @gift.save
      redirect_to admin_gifts_url, notice: 'Gift was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @gift.update(gift_params)
      redirect_to admin_gifts_url, notice: 'Gift was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @gift.destroy
    redirect_to admin_gifts_url, notice: 'Gift was successfully destroyed.'
  end

  private
  def set_gift
    @gift = Gift.find(params[:id])
  end

  def gift_params
    params.fetch(:gift, {}).permit(
      :name,
      :code,
      :amount
    )
  end

end
