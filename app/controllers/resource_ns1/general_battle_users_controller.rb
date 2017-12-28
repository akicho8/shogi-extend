# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 将棋ウォーズユーザーテーブル (general_battle_users as GeneralBattleUser)
#
# |------------+----------+-------------+-------------+------+-------|
# | カラム名   | 意味     | タイプ      | 属性        | 参照 | INDEX |
# |------------+----------+-------------+-------------+------+-------|
# | id         | ID       | integer(8)  | NOT NULL PK |      |       |
# | name       | Name     | string(255) | NOT NULL    |      | A!    |
# | created_at | 作成日時 | datetime    | NOT NULL    |      |       |
# | updated_at | 更新日時 | datetime    | NOT NULL    |      |       |
# |------------+----------+-------------+-------------+------+-------|

module ResourceNs1
  class GeneralBattleUsersController < ApplicationController
  end
end
