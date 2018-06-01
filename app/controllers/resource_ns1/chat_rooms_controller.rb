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
# | black_preset_key         | Black preset key         | string(255) | NOT NULL            |                |       |
# | white_preset_key         | White preset key         | string(255) | NOT NULL            |                |       |
# | lifetime_key             | Lifetime key             | string(255) | NOT NULL            |                |       |
# | name                     | 部屋名                   | string(255) | NOT NULL            |                |       |
# | kifu_body_sfen           | Kifu body sfen           | text(65535) | NOT NULL            |                |       |
# | clock_counts             | Clock counts             | text(65535) | NOT NULL            |                |       |
# | turn_max                 | Turn max                 | integer(4)  | NOT NULL            |                |       |
# | battle_request_at        | Battle request at        | datetime    |                     |                |       |
# | auto_matched_at          | Auto matched at          | datetime    |                     |                |       |
# | begin_at                 | Begin at                 | datetime    |                     |                |       |
# | end_at                   | End at                   | datetime    |                     |                |       |
# | last_action_key          | Last action key          | string(255) |                     |                |       |
# | win_location_key         | Win location key         | string(255) |                     |                |       |
# | current_chat_users_count | Current chat users count | integer(4)  | DEFAULT(0) NOT NULL |                |       |
# | watch_memberships_count  | Watch memberships count  | integer(4)  | DEFAULT(0) NOT NULL |                |       |
# | created_at               | 作成日時                 | datetime    | NOT NULL            |                |       |
# | updated_at               | 更新日時                 | datetime    | NOT NULL            |                |       |
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
        :lobby_chat_messages => ams_sr(LobbyChatMessage.latest_list.reverse),
        :chat_rooms          => ams_sr(ChatRoom.latest_list, include: {chat_memberships: :chat_user}),
        :online_users        => ams_sr(ChatUser.online_only),
      }
    end

    def show
      @chat_room_app_params = {
        chat_room: JSON.load(current_record.to_json({
              include: {
                :room_owner => nil,
                :chat_users => nil,
                :watch_users => nil,
                :chat_memberships => {
                  include: :chat_user,
                },
              }, methods: [
                :show_path,
                :handicap,
                :human_kifu_text,
              ],
            })),
        room_members: ams_sr(current_record.chat_memberships),
        room_chat_messages: current_record.room_chat_messages.latest_list.as_json(include: [:chat_user => {methods: [:avatar_url]}, :chat_room => {}]),
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
