require "open-uri"

module Api
  class ApplicationController < ::ApplicationController
    include ShogiErrorRescueMod

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
  end
end
