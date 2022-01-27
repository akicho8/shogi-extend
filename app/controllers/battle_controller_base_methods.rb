module BattleControllerBaseMethods
  extend ActiveSupport::Concern

  included do
    helper_method :current_turn
    helper_method :current_viewpoint
  end

  def current_turn
    @current_turn ||= yield_self do
      if v = params[:turn].presence
        v.to_i
      end
    end
  end

  def current_viewpoint
    @current_viewpoint ||= yield_self do
      if v = params[:viewpoint].presence
        v.to_sym
      end
    end
  end
end
