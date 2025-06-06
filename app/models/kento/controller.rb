module Kento
  concern :Controller do
    # http://localhost:3000/w.json?query=DevUser1&format_type=kento
    # https://www.shogi-extend.com/w.json?query=kinakom0chi&format_type=kento
    def index
      if request.format.json?
        if params[:format_type] == "kento"
          if current_swars_user
            render json: Kento::Responder.new(kento_responder_params)
          end
        end
      end

      unless performed?
        super
      end
    end

    private

    def kento_responder_params
      {
        :scope => current_swars_user.memberships.where(battle_id: current_index_scope), # これいるん？
        :user  => current_swars_user,                                                   # こっちだけでよくね？
        :max   => params[:limit],
        :notify_params => {
          :referer    => request.referer,
          :user_agent => request.user_agent,
        },
      }
    end
  end
end
