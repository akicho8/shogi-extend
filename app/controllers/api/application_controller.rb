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
        URI(url).read.toutf8
      end
    end
  end
end
