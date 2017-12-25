# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 将棋ウォーズユーザーテーブル (battle2_users as Battle2User)
#
# |-----------------------+-----------------------+-------------+-------------+-------------------+-------|
# | カラム名              | 意味                  | タイプ      | 属性        | 参照              | INDEX |
# |-----------------------+-----------------------+-------------+-------------+-------------------+-------|
# | id                    | ID                    | integer(8)  | NOT NULL PK |                   |       |
# | uid                   | Uid                   | string(255) | NOT NULL    |                   | A!    |
# | battle2_grade_id       | Battle2 grade          | integer(8)  | NOT NULL    | => Battle2Grade#id | B     |
# | last_reception_at     | Last reception at     | datetime    |             |                   |       |
# | user_receptions_count | User receptions count | integer(4)  | DEFAULT(0)  |                   |       |
# | created_at            | 作成日時              | datetime    | NOT NULL    |                   |       |
# | updated_at            | 更新日時              | datetime    | NOT NULL    |                   |       |
# |-----------------------+-----------------------+-------------+-------------+-------------------+-------|
#
#- 備考 -------------------------------------------------------------------------
# ・Battle2User モデルは Battle2Grade モデルから has_many :battle2_users されています。
#--------------------------------------------------------------------------------

module Battle2UsersHelper
end
