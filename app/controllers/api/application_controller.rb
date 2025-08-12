module Api
  class ApplicationController < ::ApplicationController
    include ShogiErrorRescueMethods # for bs_error

    def api_login_required
      if !current_user
        render json: { statusCode: 403, message: "ログインしてください" }, status: 403
      end
    end

    # FIXME: なんだこれ？ いらなかったら消す
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
          AppLog.critical(error)
          ""
        end
      end
    end

    def api_log!
      ApiOnelineLogger.new(self).perform
    end
  end
end
