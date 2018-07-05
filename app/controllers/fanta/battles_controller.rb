# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 対局テーブル (fanta_battles as Fanta::Battle)
#
# |-------------------+----------------------------------------------+-------------+---------------------+------+-------|
# | カラム名          | 意味                                         | タイプ      | 属性                | 参照 | INDEX |
# |-------------------+----------------------------------------------+-------------+---------------------+------+-------|
# | id                | ID                                           | integer(8)  | NOT NULL PK         |      |       |
# | black_preset_key  | ▲手合割                                     | string(255) | NOT NULL            |      |       |
# | white_preset_key  | △手合割                                     | string(255) | NOT NULL            |      |       |
# | lifetime_key      | 時間                                         | string(255) | NOT NULL            |      |       |
# | platoon_key       | 人数                                         | string(255) | NOT NULL            |      |       |
# | full_sfen         | USI形式棋譜                                  | text(65535) | NOT NULL            |      |       |
# | clock_counts      | 対局時計情報                                 | text(65535) | NOT NULL            |      |       |
# | countdown_flags   | 秒読み状態                                   | text(65535) | NOT NULL            |      |       |
# | turn_max          | 手番数                                       | integer(4)  | NOT NULL            |      |       |
# | battle_request_at | 対局申し込みによる成立日時                   | datetime    |                     |      |       |
# | auto_matched_at   | 自動マッチングによる成立日時                 | datetime    |                     |      |       |
# | begin_at          | メンバーたち部屋に入って対局開始になった日時 | datetime    |                     |      |       |
# | end_at            | バトル終了日時                               | datetime    |                     |      |       |
# | last_action_key   | 最後の状態                                   | string(255) |                     |      |       |
# | win_location_key  | 勝った方の先後                               | string(255) |                     |      |       |
# | memberships_count | 対局者総数                                   | integer(4)  | DEFAULT(0) NOT NULL |      |       |
# | watch_ships_count | この部屋の観戦者数                           | integer(4)  | DEFAULT(0) NOT NULL |      |       |
# | created_at        | 作成日時                                     | datetime    | NOT NULL            |      |       |
# | updated_at        | 更新日時                                     | datetime    | NOT NULL            |      |       |
# |-------------------+----------------------------------------------+-------------+---------------------+------+-------|

module Fanta
  class BattlesController < ApplicationController
    include LettableCrud::All

    let :js_lobby do
      ams_sr({}, serializer: LobbySerializer, include: {lobby_messages: :user, battles: {memberships: :user}, online_users: {active_battles: nil}})
    end

    let :js_battle do
      ams_sr(current_record, serializer: BattleShowSerializer, include: {memberships: :user, chat_messages: :user, watch_users: nil})
    end

    def show
      if current_record.xstate_key != :st_done
        @simple_layout = true
      end
    end

    def redirect_to_where
      current_record
    end
  end
end
