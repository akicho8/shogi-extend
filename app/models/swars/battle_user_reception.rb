# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Swars battle user receptionテーブル (battle_user_receptions as Swars::BattleUserReception)
#
# |----------------------+-------------------+------------+-------------+-----------------------+-------|
# | カラム名             | 意味              | タイプ     | 属性        | 参照                  | INDEX |
# |----------------------+-------------------+------------+-------------+-----------------------+-------|
# | id                   | ID                | integer(8) | NOT NULL PK |                       |       |
# | battle_user_id | Swars battle user | integer(8) | NOT NULL    | => Swars::BattleUser#id | A     |
# | created_at           | 作成日時          | datetime   | NOT NULL    |                       |       |
# | updated_at           | 更新日時          | datetime   | NOT NULL    |                       |       |
# |----------------------+-------------------+------------+-------------+-----------------------+-------|
#
#- 備考 -------------------------------------------------------------------------
# ・Swars::BattleUserReception モデルは Swars::BattleUser モデルから has_many :battle_ships されています。
#--------------------------------------------------------------------------------

class Swars::BattleUserReception < ApplicationRecord
  belongs_to :battle_user, counter_cache: true, touch: :last_reception_at
end
