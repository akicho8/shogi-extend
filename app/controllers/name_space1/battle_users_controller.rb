# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 将棋ウォーズユーザーテーブル (battle_users as BattleUser)
#
# |-----------------+-----------------+-------------+-------------+------------------+-------|
# | カラム名        | 意味            | タイプ      | 属性        | 参照             | INDEX |
# |-----------------+-----------------+-------------+-------------+------------------+-------|
# | id              | ID              | integer(8)  | NOT NULL PK |                  |       |
# | unique_key      | Unique key      | string(255) | NOT NULL    |                  |       |
# | battle_user_key | Battle user key | string(255) | NOT NULL    |                  |       |
# | battle_rank_id  | Battle rank     | integer(8)  |             | => BattleRank#id | A     |
# | created_at      | 作成日時        | datetime    | NOT NULL    |                  |       |
# | updated_at      | 更新日時        | datetime    | NOT NULL    |                  |       |
# |-----------------+-----------------+-------------+-------------+------------------+-------|
#
#- 備考 -------------------------------------------------------------------------
# ・BattleUser モデルは BattleRank モデルから has_many :battle_users されています。
#--------------------------------------------------------------------------------

module NameSpace1
  class BattleUsersController < ApplicationController
  end
end
