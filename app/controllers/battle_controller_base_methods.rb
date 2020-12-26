module BattleControllerBaseMethods
  extend ActiveSupport::Concern

  included do
    helper_method :current_turn
    helper_method :current_vpoint
  end

  let :current_turn do
    if v = params[:turn].presence
      v.to_i
    end
  end

  let :current_vpoint do
    (params[:vpoint].presence || :blank).to_sym
  end
end
