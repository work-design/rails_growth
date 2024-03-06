module Growth
  class Admin::AimCodesController < Admin::BaseController

    def index
      @aim_codes = AimCode.default_where(default_params).page(params[:page])
    end

  end
end