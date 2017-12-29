# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 将棋ウォーズユーザーテーブル (swars_battle_users as SwarsBattleUser)
#
# |------------------------------------+------------------------------------+-------------+-------------+------------------------+-------|
# | カラム名                           | 意味                               | タイプ      | 属性        | 参照                   | INDEX |
# |------------------------------------+------------------------------------+-------------+-------------+------------------------+-------|
# | id                                 | ID                                 | integer(8)  | NOT NULL PK |                        |       |
# | uid                                | Uid                                | string(255) | NOT NULL    |                        | A!    |
# | swars_battle_grade_id              | Swars battle grade                 | integer(8)  | NOT NULL    | => SwarsBattleGrade#id | B     |
# | last_reception_at                  | Last reception at                  | datetime    |             |                        |       |
# | swars_battle_user_receptions_count | Swars battle user receptions count | integer(4)  | DEFAULT(0)  |                        |       |
# | created_at                         | 作成日時                           | datetime    | NOT NULL    |                        |       |
# | updated_at                         | 更新日時                           | datetime    | NOT NULL    |                        |       |
# |------------------------------------+------------------------------------+-------------+-------------+------------------------+-------|
#
#- 備考 -------------------------------------------------------------------------
# ・SwarsBattleUser モデルは SwarsBattleGrade モデルから has_many :swars_battle_users されています。
#--------------------------------------------------------------------------------

module SwarsBattleUsersHelper
end
