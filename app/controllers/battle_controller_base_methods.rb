module BattleControllerBaseMethods
  extend ActiveSupport::Concern

  included do
    helper_method :current_turn
    helper_method :current_flip
  end

  let :current_turn do
    if v = params[:turn].presence
      v.to_i
    end
  end

  let :current_flip do
    if v = params[:flip].presence
      v == "true"
    end
  end
end
