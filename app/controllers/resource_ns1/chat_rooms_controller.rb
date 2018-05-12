# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 対戦部屋テーブル (chat_rooms as ChatRoom)
#
# |--------------------------+--------------------------+-------------+---------------------+----------------+-------|
# | カラム名                 | 意味                     | タイプ      | 属性                | 参照           | INDEX |
# |--------------------------+--------------------------+-------------+---------------------+----------------+-------|
# | id                       | ID                       | integer(8)  | NOT NULL PK         |                |       |
# | room_owner_id            | Room owner               | integer(8)  | NOT NULL            | => ChatUser#id | A     |
# | preset_key               | Preset key               | string(255) | NOT NULL            |                |       |
# | lifetime_key             | Lifetime key             | string(255) | NOT NULL            |                |       |
# | name                     | 部屋名                   | string(255) | NOT NULL            |                |       |
# | kifu_body_sfen           | Kifu body sfen           | text(65535) | NOT NULL            |                |       |
# | clock_counts             | Clock counts             | text(65535) | NOT NULL            |                |       |
# | turn_max                 | Turn max                 | integer(4)  | NOT NULL            |                |       |
# | battle_request_at        | Battle request at        | datetime    |                     |                |       |
# | auto_matched_at          | Auto matched at          | datetime    |                     |                |       |
# | battle_begin_at          | Battle begin at          | datetime    |                     |                |       |
# | battle_end_at            | Battle end at            | datetime    |                     |                |       |
# | win_location_key         | Win location key         | string(255) |                     |                |       |
# | give_up_location_key     | Give up location key     | string(255) |                     |                |       |
# | created_at               | 作成日時                 | datetime    | NOT NULL            |                |       |
# | updated_at               | 更新日時                 | datetime    | NOT NULL            |                |       |
# | current_chat_users_count | Current chat users count | integer(4)  | DEFAULT(0) NOT NULL |                |       |
# | watch_memberships_count | Watch memberships count | integer(4)  | DEFAULT(0) NOT NULL |                |       |
# |--------------------------+--------------------------+-------------+---------------------+----------------+-------|
#
#- 備考 -------------------------------------------------------------------------
# ・ChatRoom モデルは ChatUser モデルから has_many :owner_rooms, :foreign_key => :room_owner_id されています。
#--------------------------------------------------------------------------------

module ResourceNs1
  class ChatRoomsController < ApplicationController
    include ModulableCrud::All

    before_action do
      @lobby_app_params = {
        preset_infos: Warabi::PresetInfo.collect { |e| e.attributes.merge(name: e.key) },
        lifetime_infos: LifetimeInfo.collect(&:attributes),
        lobby_chat_messages: JSON.load(LobbyChatMessage.order(:created_at).last(10).to_json(include: :chat_user)),
        chat_rooms: JSON.load(ChatRoom.latest_list.to_json(ChatRoom.to_json_params)),
        online_users: ChatUser.where.not(online_at: nil),
      }
    end

    def show
      @chat_room_app_params = {
        chat_room: current_record.js_attributes,
        room_members: current_record.js_room_members,
        player_mode_moved_path: url_for([:resource_ns1, current_record, :kifu_valids, format: "json"]),
      }
    end

    def raw_current_record
      super.tap do |e|
        e.room_owner ||= current_chat_user
        e.name ||= e.name_default
      end
    end

    def redirect_to_where
      [self.class.parent_name.underscore, current_record]
    end
  end
end
