# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 棋譜変換テーブル (battle_users as BattleUser)
#
# |---------------------+--------------------+----------+-------------+----------------------+-------|
# | カラム名            | 意味               | タイプ   | 属性        | 参照                 | INDEX |
# |---------------------+--------------------+----------+-------------+----------------------+-------|
# | id                  | ID                 | integer  | NOT NULL PK |                      |       |
# | unique_key          | ユニークなハッシュ | string   | NOT NULL    |                      |       |
# | user_key            | User key           | string   | NOT NULL    |                      |       |
# | battle_user_rank_id | Battle user rank   | integer  |             | => BattleUserRank#id | A     |
# | created_at          | 作成日時           | datetime | NOT NULL    |                      |       |
# | updated_at          | 更新日時           | datetime | NOT NULL    |                      |       |
# |---------------------+--------------------+----------+-------------+----------------------+-------|
#
#- 備考 -------------------------------------------------------------------------
# ・BattleUser モデルは BattleUserRank モデルから has_many :battle_users されています。
#--------------------------------------------------------------------------------

module BattleUsersHelper
end
