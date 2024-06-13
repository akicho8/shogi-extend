# frozen-string-literal: true

module Swars
  module User::Vip
    extend self

    def auto_crawl_user_keys
      fetch(:swars_user_vip_auto_crawl_user_keys) + fetch(:honwaka_line_group_user_keys)
    end

    def long_time_keep_user_keys
      fetch(:swars_user_vip_long_time_keep_user_keys) + fetch(:honwaka_line_group_user_keys)
    end

    def protected_user_keys
      fetch(:swars_user_vip_protected_user_keys)
    end

    private

    def fetch(...)
      Rails.application.credentials.fetch(...)
    end
  end
end
