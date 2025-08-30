module Kento
  concern :Controller do
    # Amazon EC2 からのアクセスは IP がバラバラなため攻撃を防ぐことができない
    # if Rails.env.local?
    #   included do
    #     rate_limit to: 1, within: 1.second, only: :index, by: -> { request.remote_ip }, :if => -> {
    #       params[:format_type] == "kento" && current_swars_user
    #     }
    #   end
    # end

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
        :user => current_swars_user,
        :max  => params[:limit],
        :notify_params => {
          :referer    => request.referer,
          :user_agent => request.user_agent,
          :remote_ip  => request.remote_ip,
        },
      }
    end
  end
end
