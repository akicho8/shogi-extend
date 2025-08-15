# frozen-string-literal: true

module Swars
  module User::Vip
    extend self

    def auto_crawl_user_keys
      group(:honwaka, :pro, :semi_pro, :youtuber, :twitter, :comedian, :tiktoker, :amateur, :other, :heroz)
    end

    def long_time_keep_user_keys
      group(:honwaka, :pro, :semi_pro, :youtuber, :twitter, :comedian, :tiktoker, :amateur, :other)
    end

    def protected_user_keys
      group # group(:pro, :semi_pro, :protected)
    end

    def group(*keys)
      keys.flat_map { |e| fetch(e) }
    end

    def fetch(...)
      Rails.application.credentials.swars.user_keys.fetch(...)
    end
  end
end
