# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Swars battle record access logテーブル (access_logs as AccessLog)
#
# |------------------------+---------------------+------------+-------------+-------------------------+-------|
# | カラム名               | 意味                | タイプ     | 属性        | 参照                    | INDEX |
# |------------------------+---------------------+------------+-------------+-------------------------+-------|
# | id                     | ID                  | integer(8) | NOT NULL PK |                         |       |
# | battle_id | Swars battle record | integer(8) | NOT NULL    | => Battle#id | A     |
# | created_at             | 作成日時            | datetime   | NOT NULL    |                         |       |
# | updated_at             | 更新日時            | datetime   | NOT NULL    |                         |       |
# |------------------------+---------------------+------------+-------------+-------------------------+-------|
#
#- 備考 -------------------------------------------------------------------------
# ・AccessLog モデルは Battle モデルから has_many :memberships されています。
#--------------------------------------------------------------------------------

module Swars
  class AccessLog < ApplicationRecord
    belongs_to :battle, counter_cache: true, touch: :last_accessd_at
  end
end
