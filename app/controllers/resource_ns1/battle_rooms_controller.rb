# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 対戦部屋テーブル (battle_rooms as BattleRoom)
#
# |--------------------------+--------------------------+-------------+---------------------+------+-------|
# | カラム名                 | 意味                     | タイプ      | 属性                | 参照 | INDEX |
# |--------------------------+--------------------------+-------------+---------------------+------+-------|
# | id                       | ID                       | integer(8)  | NOT NULL PK         |      |       |
# | black_preset_key         | Black preset key         | string(255) | NOT NULL            |      |       |
# | white_preset_key         | White preset key         | string(255) | NOT NULL            |      |       |
# | lifetime_key             | Lifetime key             | string(255) | NOT NULL            |      |       |
# | kifu_body_sfen           | Kifu body sfen           | text(65535) | NOT NULL            |      |       |
# | clock_counts             | Clock counts             | text(65535) | NOT NULL            |      |       |
# | countdown_mode_hash      | Countdown mode hash      | text(65535) | NOT NULL            |      |       |
# | turn_max                 | Turn max                 | integer(4)  | NOT NULL            |      |       |
# | battle_request_at        | Battle request at        | datetime    |                     |      |       |
# | auto_matched_at          | Auto matched at          | datetime    |                     |      |       |
# | begin_at                 | Begin at                 | datetime    |                     |      |       |
# | end_at                   | End at                   | datetime    |                     |      |       |
# | last_action_key          | Last action key          | string(255) |                     |      |       |
# | win_location_key         | Win location key         | string(255) |                     |      |       |
# | current_users_count | Current chat users count | integer(4)  | DEFAULT(0) NOT NULL |      |       |
# | watch_memberships_count  | Watch memberships count  | integer(4)  | DEFAULT(0) NOT NULL |      |       |
# | created_at               | 作成日時                 | datetime    | NOT NULL            |      |       |
# | updated_at               | 更新日時                 | datetime    | NOT NULL            |      |       |
# |--------------------------+--------------------------+-------------+---------------------+------+-------|

module ResourceNs1
  class BattleRoomsController < ApplicationController
    include ModulableCrud::All

    before_action do
      @lobby_app_params = {
        :lobby_messages => ams_sr(LobbyMessage.latest_list.reverse),
        :battle_rooms          => ams_sr(BattleRoom.latest_list, include: {memberships: :user}, each_serializer: BattleRoomEachSerializer),
        :online_users        => ams_sr(User.online_only),
      }
    end

    def show
      @js_current_battle_room = ams_sr(current_record, include: {memberships: :user, chat_messages: :user})
    end

    def redirect_to_where
      [self.class.parent_name.underscore, current_record]
    end
  end
end
