module Api
  class EtcController < ::Api::ApplicationController
    skip_forgery_protection

    # curl -X GET  http://localhost:3000/api/echo.json?message=ok
    # curl -X POST http://localhost:3000/api/echo.json?message=ok
    def echo
      render json: {
        :message   => params[:message],
        :timestamp => Time.current,
      }
    end

    # curl -X GET http://localhost:3000/api/sleep.json?sleep=2
    def sleep
      if Rails.env.development?
        Kernel.sleep(params[:sleep].to_f)
      end
      render json: params[:retval]
    end

    # http://localhost:3000/api/ping.json
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

    # http://localhost:3000/api/app_log.json
    def app_log
      hv = params.to_unsafe_h.to_options
      if true
        subject = []
        if current_user
          subject << "[#{current_user.id}][#{current_user.name}]"
        end
        subject << hv[:subject]
        hv[:subject] = subject.compact.join(" ")
      end
      AppLog.call(**hv)
      render json: { :message => "OK" }
    end
  end
end
