# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Swars battle record access logテーブル (swars_battle_record_access_logs as SwarsBattleRecordAccessLog)
#
# |------------------------+---------------------+------------+-------------+-------------------------+-------|
# | カラム名               | 意味                | タイプ     | 属性        | 参照                    | INDEX |
# |------------------------+---------------------+------------+-------------+-------------------------+-------|
# | id                     | ID                  | integer(8) | NOT NULL PK |                         |       |
# | swars_battle_record_id | Swars battle record | integer(8) | NOT NULL    | => SwarsBattleRecord#id | A     |
# | created_at             | 作成日時            | datetime   | NOT NULL    |                         |       |
# | updated_at             | 更新日時            | datetime   | NOT NULL    |                         |       |
# |------------------------+---------------------+------------+-------------+-------------------------+-------|
#
#- 備考 -------------------------------------------------------------------------
# ・SwarsBattleRecordAccessLog モデルは SwarsBattleRecord モデルから has_many :swars_battle_ships されています。
#--------------------------------------------------------------------------------

class SwarsBattleRecordAccessLog < ApplicationRecord
  belongs_to :swars_battle_record, counter_cache: true, touch: :last_accessd_at
end
