require "open-uri"

module Api
  class ApplicationController < ::ApplicationController
    include ShogiErrorRescueMethods # for bs_error

    before_action do
      if Rails.env.development? || Rails.env.staging? || params["__SERVER_ENV_SHOW__"]
        SlackAgent.notify(subject: "API", body: request.env.find_all {|k, v| k.to_s.match?(/^[A-Z]/) }.to_h)
      end
    end

    def api_login_required
      if !current_user
        render json: { statusCode: 403, message: "ログインしてください" }, status: 403
      end
    end

    def html_fetch(url, options = {})
      options = {
        expires_in: 1.hour,
      }.merge(options)

      key = [:html_fetch, Digest::MD5.hexdigest(url)].join
      Rails.cache.fetch(key, options) do
        Rails.logger.debug("html_fetch: #{url}")
        begin
          URI(url).read.toutf8
        rescue SocketError => error
          Rails.logger.info(error)
          SlackSos.notify_exception(error)
          ExceptionNotifier.notify_exception(error)
          ""
        end
      end
    end

    def api_log!
      if request.origin.to_s == AppConfig[:server_origin]
        return
      end
      agent = request.from || request.origin
      SlackAgent.notify(subject: "(#{agent}) #{request.request_uri}", body: params, emoji: ":API:")
    end
  end
end
