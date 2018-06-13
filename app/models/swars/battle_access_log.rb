# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Swars battle record access logテーブル (battle_access_logs as Swars::BattleAccessLog)
#
# |------------------------+---------------------+------------+-------------+-------------------------+-------|
# | カラム名               | 意味                | タイプ     | 属性        | 参照                    | INDEX |
# |------------------------+---------------------+------------+-------------+-------------------------+-------|
# | id                     | ID                  | integer(8) | NOT NULL PK |                         |       |
# | battle_record_id | Swars battle record | integer(8) | NOT NULL    | => Swars::BattleRecord#id | A     |
# | created_at             | 作成日時            | datetime   | NOT NULL    |                         |       |
# | updated_at             | 更新日時            | datetime   | NOT NULL    |                         |       |
# |------------------------+---------------------+------------+-------------+-------------------------+-------|
#
#- 備考 -------------------------------------------------------------------------
# ・Swars::BattleAccessLog モデルは Swars::BattleRecord モデルから has_many :battle_ships されています。
#--------------------------------------------------------------------------------

class Swars::BattleAccessLog < ApplicationRecord
  belongs_to :battle_record, counter_cache: true, touch: :last_accessd_at
end
