module ShortUrl
  class AccessLog < ApplicationRecord
    belongs_to :component, counter_cache: true, touch: true

    after_create do
      AppLog.info(subject: log_subject, body: log_body)
    end

    def log_subject
      "短縮URLリダイレクト(#{component.access_logs_count}回目)"
    end

    def log_body
      [
        component.compact_url,
        component.original_url,
      ].join(" ")
    end
  end
end
