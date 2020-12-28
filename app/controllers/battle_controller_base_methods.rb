module BattleControllerBaseMethods
  extend ActiveSupport::Concern

  included do
    helper_method :current_turn
    helper_method :current_viewpoint
  end

  let :current_turn do
    if v = params[:turn].presence
      v.to_i
    end
  end

  let :current_viewpoint do
    if v = params[:viewpoint].presence
      v.to_sym
    end
  end
end
