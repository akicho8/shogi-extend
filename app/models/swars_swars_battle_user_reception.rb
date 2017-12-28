# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Battle user receptionテーブル (swars_swars_battle_user_receptions as SwarsSwarsBattleUserReception)
#
# |----------------+-------------+------------+-------------+------------------+-------|
# | カラム名       | 意味        | タイプ     | 属性        | 参照             | INDEX |
# |----------------+-------------+------------+-------------+------------------+-------|
# | id             | ID          | integer(8) | NOT NULL PK |                  |       |
# | swars_battle_user_id | Battle user | integer(8) | NOT NULL    | => SwarsBattleUser#id | A     |
# | created_at     | 作成日時    | datetime   | NOT NULL    |                  |       |
# | updated_at     | 更新日時    | datetime   | NOT NULL    |                  |       |
# |----------------+-------------+------------+-------------+------------------+-------|
#
#- 備考 -------------------------------------------------------------------------
# ・SwarsSwarsBattleUserReception モデルは SwarsBattleUser モデルから has_many :swars_battle_ships されています。
#--------------------------------------------------------------------------------

class SwarsSwarsBattleUserReception < ApplicationRecord
  belongs_to :swars_battle_user, counter_cache: true, touch: :last_reception_at
end
