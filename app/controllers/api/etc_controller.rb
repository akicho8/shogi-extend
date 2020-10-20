module Api
  class EtcController < ::Api::ApplicationController
    skip_forgery_protection

    # curl -X GET  http://0.0.0.0:3000/api/echo.json?message=ok
    # curl -X POST http://0.0.0.0:3000/api/echo.json?message=ok
    def echo
      render json: {
        :message   => params[:message],
        :timestamp => Time.current,
      }
    end

    # http://0.0.0.0:3000/api/ping.json
    def ping
      render json: {
        :message   => "PONG",
        :timestamp => Time.current,
        :params    => params,
        :request => {
          :format => {
            :to_s   => request.format.to_s,
            :to_sym => request.format.to_sym,
            :ref    => request.format.ref,
          },
          :accept            => request.accept,
          :accept            => request.accept,
          :accept_charset    => request.accept_charset,
          :accept_encoding   => request.accept_encoding,
          :accept_language   => request.accept_language,
          :auth_type         => request.auth_type,
          :cache_control     => request.cache_control,
          :content_length    => request.content_length,
          :content_type      => request.content_type,
          :from              => request.from,
          :gateway_interface => request.gateway_interface,
          :host              => request.host,
          :negotiate         => request.negotiate,
          :path_info         => request.path_info,
          :path_translated   => request.path_translated,
          :pragma            => request.pragma,
          :query_string      => request.query_string,
          :referer           => request.referer,
          :remote_addr       => request.remote_addr,
          :remote_host       => request.remote_host,
          :remote_ident      => request.remote_ident,
          :remote_user       => request.remote_user,
          :request_method    => request.request_method,
          :script_name       => request.script_name,
          :server_name       => request.server_name,
          :server_port       => request.server_port,
          :server_protocol   => request.server_protocol,
          :server_software   => request.server_software,
          :user_agent        => request.user_agent,
        }
      }
    end

    # 三段リーグのユーザー配列
    # http://0.0.0.0:3000/api/tsl_user_all
    def tsl_user_all
      render json: Tsl::User.all
    end

    # 三段リーグのユーザーの代表
    # http://0.0.0.0:3000/api/tsl_user_newest
    def tsl_user_newest
      render json: Tsl::League.newest_order.first.users.where.not(level_up_generation: nil).sample
    end

    # 三段リーグのリーグ配列
    # http://0.0.0.0:3000/api/tsl_league_all
    def tsl_league_all
      render json: Tsl::League.all
    end

    # 三段リーグの最新
    # http://0.0.0.0:3000/api/tsl_league_newest
    def tsl_league_newest
      render json: Tsl::League.newest_order.first
    end
  end
end
