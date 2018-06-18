# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 棋譜変換テーブル (free_battles as FreeBattle)
#
# |------------+--------------------+-------------+-------------+------+-------|
# | カラム名   | 意味               | タイプ      | 属性        | 参照 | INDEX |
# |------------+--------------------+-------------+-------------+------+-------|
# | id         | ID                 | integer(8)  | NOT NULL PK |      |       |
# | key        | ユニークなハッシュ | string(255) | NOT NULL    |      | A!    |
# | kifu_url   | 棋譜URL            | string(255) |             |      |       |
# | kifu_body  | 棋譜内容           | text(65535) | NOT NULL    |      |       |
# | turn_max   | 手数               | integer(4)  | NOT NULL    |      |       |
# | meta_info  | 棋譜ヘッダー       | text(65535) | NOT NULL    |      |       |
# | battled_at | Battled at         | datetime    | NOT NULL    |      |       |
# | created_at | 作成日時           | datetime    | NOT NULL    |      |       |
# | updated_at | 更新日時           | datetime    | NOT NULL    |      |       |
# |------------+--------------------+-------------+-------------+------+-------|

module FreeBattlesHelper
end
