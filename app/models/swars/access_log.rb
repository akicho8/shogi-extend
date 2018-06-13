# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Swars battle record access logテーブル (access_logs as Swars::AccessLog)
#
# |------------------------+---------------------+------------+-------------+-------------------------+-------|
# | カラム名               | 意味                | タイプ     | 属性        | 参照                    | INDEX |
# |------------------------+---------------------+------------+-------------+-------------------------+-------|
# | id                     | ID                  | integer(8) | NOT NULL PK |                         |       |
# | battle_id | Swars battle record | integer(8) | NOT NULL    | => Swars::Battle#id | A     |
# | created_at             | 作成日時            | datetime   | NOT NULL    |                         |       |
# | updated_at             | 更新日時            | datetime   | NOT NULL    |                         |       |
# |------------------------+---------------------+------------+-------------+-------------------------+-------|
#
#- 備考 -------------------------------------------------------------------------
# ・Swars::AccessLog モデルは Swars::Battle モデルから has_many :memberships されています。
#--------------------------------------------------------------------------------

class Swars::AccessLog < ApplicationRecord
  belongs_to :battle, counter_cache: true, touch: :last_accessd_at
end
