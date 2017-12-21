# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 将棋ウォーズユーザーテーブル (battle_users as BattleUser)
#
# |-----------------------+-----------------------+-------------+-------------+-------------------+-------|
# | カラム名              | 意味                  | タイプ      | 属性        | 参照              | INDEX |
# |-----------------------+-----------------------+-------------+-------------+-------------------+-------|
# | id                    | ID                    | integer(8)  | NOT NULL PK |                   |       |
# | uid                   | Uid                   | string(255) | NOT NULL    |                   | A!    |
# | battle_grade_id       | Battle grade          | integer(8)  | NOT NULL    | => BattleGrade#id | B     |
# | created_at            | 作成日時              | datetime    | NOT NULL    |                   |       |
# | updated_at            | 更新日時              | datetime    | NOT NULL    |                   |       |
# | user_receptions_count | User receptions count | integer(4)  | DEFAULT(0)  |                   |       |
# | last_reception_at     | Last reception at     | datetime    |             |                   |       |
# |-----------------------+-----------------------+-------------+-------------+-------------------+-------|
#
#- 備考 -------------------------------------------------------------------------
# ・BattleUser モデルは BattleGrade モデルから has_many :battle_users されています。
#--------------------------------------------------------------------------------

module ResourceNs1
  class BattleUsersController < ApplicationController
  end
end
