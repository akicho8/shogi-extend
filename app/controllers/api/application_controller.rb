require "open-uri"

module Api
  class ApplicationController < ::ApplicationController
    include ShogiErrorRescueMethods # for bs_error

    def api_login_required
      unless current_user
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
          SlackAgent.notify_exception(error)
          ExceptionNotifier.notify_exception(error)
          ""
        end
      end
    end

    private

    def data_uri_scheme_to_bin(data_base64_body)
      md = data_base64_body.match(/\A(data):(?<content_type>.*?);base64,(?<base64_bin>.*)/)
      md or raise ArgumentError, "Data URL scheme 形式になっていません : #{data_base64_body.inspect.truncate(80)}"
      Base64.decode64(md["base64_bin"])
    end
  end
end
