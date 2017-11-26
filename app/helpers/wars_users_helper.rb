# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 将棋ウォーズユーザーテーブル (wars_users as WarsUser)
#
# |--------------+------------+-------------+-------------+----------------+-------|
# | カラム名     | 意味       | タイプ      | 属性        | 参照           | INDEX |
# |--------------+------------+-------------+-------------+----------------+-------|
# | id           | ID         | integer(8)  | NOT NULL PK |                |       |
# | unique_key   | Unique key | string(255) | NOT NULL    |                |       |
# | user_key     | User key   | string(255) | NOT NULL    |                |       |
# | wars_rank_id | Wars rank  | integer(8)  |             | => WarsRank#id | A     |
# | created_at   | 作成日時   | datetime    | NOT NULL    |                |       |
# | updated_at   | 更新日時   | datetime    | NOT NULL    |                |       |
# |--------------+------------+-------------+-------------+----------------+-------|
#
#- 備考 -------------------------------------------------------------------------
# ・WarsUser モデルは WarsRank モデルから has_many :wars_users されています。
#--------------------------------------------------------------------------------

module WarsUsersHelper
end
