# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 将棋ウォーズユーザーテーブル (wars_users as WarsUser)
#
# |--------------+------------+----------+-------------+----------------+-------|
# | カラム名     | 意味       | タイプ   | 属性        | 参照           | INDEX |
# |--------------+------------+----------+-------------+----------------+-------|
# | id           | ID         | integer  | NOT NULL PK |                |       |
# | unique_key   | Unique key | string   | NOT NULL    |                |       |
# | user_key     | User key   | string   | NOT NULL    |                |       |
# | wars_rank_id | Wars rank  | integer  |             | => WarsRank#id | A     |
# | created_at   | 作成日時   | datetime | NOT NULL    |                |       |
# | updated_at   | 更新日時   | datetime | NOT NULL    |                |       |
# |--------------+------------+----------+-------------+----------------+-------|
#
#- 備考 -------------------------------------------------------------------------
# ・WarsUser モデルは WarsRank モデルから has_many :wars_users されています。
#--------------------------------------------------------------------------------

module WarsUsersHelper
end
