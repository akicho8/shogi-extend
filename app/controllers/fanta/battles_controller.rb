# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 対局テーブル (fanta_battles as Fanta::Battle)
#
# |---------------------+---------------------+-------------+---------------------+------+-------|
# | カラム名            | 意味                | タイプ      | 属性                | 参照 | INDEX |
# |---------------------+---------------------+-------------+---------------------+------+-------|
# | id                  | ID                  | integer(8)  | NOT NULL PK         |      |       |
# | black_preset_key    | Black preset key    | string(255) | NOT NULL            |      |       |
# | white_preset_key    | White preset key    | string(255) | NOT NULL            |      |       |
# | lifetime_key        | Lifetime key        | string(255) | NOT NULL            |      |       |
# | platoon_key         | Platoon key         | string(255) | NOT NULL            |      |       |
# | full_sfen      | Kifu body sfen      | text(65535) | NOT NULL            |      |       |
# | clock_counts        | Clock counts        | text(65535) | NOT NULL            |      |       |
# | countdown_flags | Countdown mode hash | text(65535) | NOT NULL            |      |       |
# | turn_max            | Turn max            | integer(4)  | NOT NULL            |      |       |
# | battle_request_at   | Battle request at   | datetime    |                     |      |       |
# | auto_matched_at     | Auto matched at     | datetime    |                     |      |       |
# | begin_at            | Begin at            | datetime    |                     |      |       |
# | end_at              | End at              | datetime    |                     |      |       |
# | last_action_key     | Last action key     | string(255) |                     |      |       |
# | win_location_key    | Win location key    | string(255) |                     |      |       |
# | current_users_count | Current users count | integer(4)  | DEFAULT(0) NOT NULL |      |       |
# | watch_ships_count   | Watch ships count   | integer(4)  | DEFAULT(0) NOT NULL |      |       |
# | created_at          | 作成日時            | datetime    | NOT NULL            |      |       |
# | updated_at          | 更新日時            | datetime    | NOT NULL            |      |       |
# |---------------------+---------------------+-------------+---------------------+------+-------|

module Fanta
  class BattlesController < ApplicationController
    include ModulableCrud::All

    def index
      @js_lobby = ams_sr({}, serializer: LobbySerializer, include: {lobby_messages: :user, battles: {memberships: :user}, online_users: nil})
    end

    def show
      @js_battle = ams_sr(current_record, serializer: BattleShowSerializer, include: {memberships: :user, chat_messages: :user, watch_users: nil})
    end

    def redirect_to_where
      [self.class.parent_name.underscore, current_record]
    end
  end
end
