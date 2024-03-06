module Growth
  class Admin::AimsController < Admin::BaseController
    before_action :set_aim, only: [:show, :edit, :update, :destroy, :actions]
    before_action :set_new_aim, only: [:new, :create]

    def index
      @aims = Aim.includes(:aim_codes).order(id: :desc).page(params[:page])
    end

    def new
      @aim.aim_codes.build
    end

    def edit
      if @aim.aim_codes.count == 0
        @aim.aim_codes.build
      end
    end

    private
    def set_aim
      @aim = Aim.find(params[:id])
    end

    def set_new_aim
      @aim = Aim.new(aim_params)
    end

    def aim_params
      params.fetch(:aim, {}).permit(
        :name,
        :task_point,
        :reward_point,
        :unit,
        :rate,
        :repeat_type,
        :reward_amount,
        aim_codes_attributes: {}
      )
    end

  end
end
