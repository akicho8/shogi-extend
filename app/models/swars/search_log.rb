# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Search logテーブル (swars_search_logs as Swars::SearchLog)
#
# |------------+----------+------------+-------------+------+-------|
# | カラム名   | 意味     | タイプ     | 属性        | 参照 | INDEX |
# |------------+----------+------------+-------------+------+-------|
# | id         | ID       | integer(8) | NOT NULL PK |      |       |
# | user_id    | User     | integer(8) | NOT NULL    |      | A     |
# | created_at | 作成日時 | datetime   | NOT NULL    |      |       |
# | updated_at | 更新日時 | datetime   | NOT NULL    |      |       |
# |------------+----------+------------+-------------+------+-------|

module Swars
  class SearchLog < ApplicationRecord
    belongs_to :user, counter_cache: true, touch: :last_reception_at
  end
end
