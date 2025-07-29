# -*- coding: utf-8 -*-

# == Schema Information ==
#
# Component (short_url_components as ShortUrl::Component)
#
# |-------------------+-------------------+--------------+---------------------+------+-------|
# | name              | desc              | type         | opts                | refs | index |
# |-------------------+-------------------+--------------+---------------------+------+-------|
# | id                | ID                | integer(8)   | NOT NULL PK         |      |       |
# | key               | キー              | string(255)  | NOT NULL            |      | A!    |
# | original_url      | Original url      | string(2048) | NOT NULL            |      |       |
# | access_logs_count | Access logs count | integer(4)   | DEFAULT(0) NOT NULL |      |       |
# | created_at        | 作成日時          | datetime     | NOT NULL            |      |       |
# | updated_at        | 更新日時          | datetime     | NOT NULL            |      |       |
# |-------------------+-------------------+--------------+---------------------+------+-------|

module ShortUrl
  class Component < ApplicationRecord
    class << self
      # key からレコードを取得する
      def fetch(params)
        fetch_by_id_param(params) || find_by!(key: params[:key])
      end

      def fetch_by_id_param(params)
        if Rails.env.local?
          if id = params[:id].presence
            find(id)
          end
        end
      end

      # 長いURLから短縮URLに直接変換する
      def from(original_url)
        original_url.present? or raise ArgumentError
        key = AlnumHash.call(original_url)
        record = find_by(key: key)
        record ||= create!(key: key, original_url: original_url)
      end

      def transform(...)
        from(...).compact_url
      end

      def [](...)
        transform(...)
      end

      def key(...)
        from(...).key
      end

      def root_url
        Rails.application.routes.url_helpers.url_for(:root)
      end
    end

    has_many :access_logs, class_name: "ShortUrl::AccessLog", dependent: :destroy # アクセス記録たち

    before_validation do
      self.key ||= AlnumHash.call(original_url)
    end

    with_options presence: true do
      validates :key
      validates :original_url
    end

    after_create do
      AppLog.info(emoji: ":短縮URL:", subject: "短縮URL作成", body: [compact_url, original_url].join("\n"))
    end

    def compact_url
      "#{self.class.root_url}u/#{key}"
    end

    def as_json(*)
      super.merge(compact_url: compact_url)
    end
  end
end
