# -*- coding: utf-8 -*-

# == Schema Information ==
#
# Access log (short_url_access_logs as ShortUrl::AccessLog)
#
# |--------------+-----------+------------+-------------+------+-------|
# | name         | desc      | type       | opts        | refs | index |
# |--------------+-----------+------------+-------------+------+-------|
# | id           | ID        | integer(8) | NOT NULL PK |      |       |
# | component_id | Component | integer(8) |             |      | A     |
# | created_at   | 作成日時  | datetime   | NOT NULL    |      |       |
# |--------------+-----------+------------+-------------+------+-------|

module ShortUrl
  class AccessLog < ApplicationRecord
    belongs_to :component, counter_cache: true, touch: true

    after_create do
      AppLog.info(subject: log_subject, body: log_body)
    end

    def log_subject
      "[短縮URL][転送] (#{component.access_logs_count}回目)"
    end

    def log_body
      [
        component.compact_url,
        component.original_url,
      ].join(" ")
    end
  end
end
