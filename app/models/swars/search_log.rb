# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Swars battle user receptionテーブル (search_logs as SearchLog)
#
# |----------------------+-------------------+------------+-------------+-----------------------+-------|
# | カラム名             | 意味              | タイプ     | 属性        | 参照                  | INDEX |
# |----------------------+-------------------+------------+-------------+-----------------------+-------|
# | id                   | ID                | integer(8) | NOT NULL PK |                       |       |
# | user_id | Swars battle user | integer(8) | NOT NULL    | => User#id | A     |
# | created_at           | 作成日時          | datetime   | NOT NULL    |                       |       |
# | updated_at           | 更新日時          | datetime   | NOT NULL    |                       |       |
# |----------------------+-------------------+------------+-------------+-----------------------+-------|
#
#- 備考 -------------------------------------------------------------------------
# ・SearchLog モデルは User モデルから has_many :memberships されています。
#--------------------------------------------------------------------------------

module Swars
  class SearchLog < ApplicationRecord
    belongs_to :user, counter_cache: true, touch: :last_reception_at
  end
end
