module BattleControllerBaseMethods
  extend ActiveSupport::Concern

  included do
    helper_method :current_turn
  end

  let :current_turn do
    if v = params[:turn].presence
      v.to_i
    end
  end
end
