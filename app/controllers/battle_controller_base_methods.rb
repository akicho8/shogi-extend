module BattleControllerBaseMethods
  extend ActiveSupport::Concern

  included do
    helper_method :current_record_turn
    helper_method :current_force_turn
  end

  let :current_force_turn do
    if v = (params[:force_turn] || params[:turn]).presence
      v.to_i
    end
  end

  let :current_record_turn do
    current_force_turn || current_record.sp_turn
  end
end
