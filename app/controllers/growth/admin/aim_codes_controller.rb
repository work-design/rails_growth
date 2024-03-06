module Growth
  class Admin::AimCodesController < Admin::BaseController
    before_action :set_aim
    before_action :set_new_aim_code, only: [:new, :create]
    def index
      @aim_codes = AimCode.default_where(default_params).page(params[:page])
    end

    private
    def set_aim
      @aim = Aim.find params[:aim_id]
    end

    def set_new_aim_code
      @aim_code = @aim.aim_codes.build(aim_code_params)
    end

    def aim_code_params
      params.fetch(:aim_code, {}).permit(
        :controller_path,
        :action_name
      )
    end

  end
end