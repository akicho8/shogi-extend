# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Room chat messageテーブル (room_chat_messages as RoomChatMessage)
#
# |--------------+-----------+-------------+-------------+----------------+-------|
# | カラム名     | 意味      | タイプ      | 属性        | 参照           | INDEX |
# |--------------+-----------+-------------+-------------+----------------+-------|
# | id           | ID        | integer(8)  | NOT NULL PK |                |       |
# | chat_room_id | Chat room | integer(8)  | NOT NULL    | => ChatRoom#id | A     |
# | chat_user_id | Chat user | integer(8)  | NOT NULL    | => ChatUser#id | B     |
# | message      | Message   | text(65535) | NOT NULL    |                |       |
# | created_at   | 作成日時  | datetime    | NOT NULL    |                |       |
# | updated_at   | 更新日時  | datetime    | NOT NULL    |                |       |
# |--------------+-----------+-------------+-------------+----------------+-------|
#
#- 備考 -------------------------------------------------------------------------
# ・RoomChatMessage モデルは ChatRoom モデルから has_many :room_chat_messages されています。
# ・RoomChatMessage モデルは ChatUser モデルから has_many :room_chat_messages されています。
#--------------------------------------------------------------------------------

class CreateRoomChatMessages < ActiveRecord::Migration[5.1]
  def up
    create_table :chat_users, force: true do |t|
      t.string :name, null: false
      t.belongs_to :current_chat_room
      t.datetime :online_at
      t.datetime :fighting_now_at, comment: "chat_memberships.fighting_now_at と同じでこれを見ると対局中かどうかがすぐにわかる"
      t.datetime :matching_at
      t.string :lifetime_key, index: true
      t.string :ps_preset_key, index: true
      t.string :po_preset_key, index: true
      t.timestamps null: false
    end
    create_table :chat_rooms, force: true do |t|
      t.belongs_to :room_owner,                        null: false, comment: "部屋を作った人(とくに利用していなが親メンバーを特定したいときに使う)",
      t.string :preset_key,                            null: false, comment: "手合割",
      t.string :lifetime_key,                          null: false, comment: "時間",
      t.string :name,                                  null: false, comment: "部屋名",
      t.text :kifu_body_sfen,                          null: false, comment: "USI形式棋譜",
      t.text :clock_counts,                            null: false, comment: "対局時計情報",
      t.integer :turn_max,                             null: false, comment: "手番数",
      t.datetime :battle_request_at,                                comment: "対局申し込みによる成立日時"
      t.datetime :auto_matched_at,                                  comment: "自動マッチングによる成立日時"
      t.datetime :battle_begin_at,                                  comment: "メンバーたち部屋に入って対局開始になった日時"
      t.datetime :battle_end_at,                                    comment: "バトル終了日時"
      t.string :win_location_key,                                   comment: "勝った方の先後"
      t.string :give_up_location_key,                               comment: "投了した側(投了した場合のみ)"
      t.timestamps                                     null: false
      t.integer :current_chat_users_count, default: 0, null: false
      t.integer :watch_memberships_count, default: 0,  null: false
    end
    create_table :chat_memberships, force: true do |t|
      t.string :preset_key, null: false
      t.belongs_to :chat_room, null: false
      t.belongs_to :chat_user, null: false
      t.string :location_key, null: false, index: true, comment: "▲△"
      t.integer :position, index: true, comment: "入室順序"
      t.datetime :standby_at, comment: "準備完了日時"
      t.datetime :fighting_now_at, comment: "部屋に入った日時で抜けたり切断するとnull"
      t.timestamps null: false
    end
    create_table :watch_memberships, force: true do |t|
      t.belongs_to :chat_room, null: false
      t.belongs_to :chat_user, null: false
      t.timestamps null: false
    end
    create_table :room_chat_messages, force: true do |t|
      t.belongs_to :chat_room, null: false, comment: "部屋"
      t.belongs_to :chat_user, null: false, comment: "人"
      t.text :message, null: false
      t.timestamps null: false
    end
    create_table :lobby_chat_messages, force: true do |t|
      t.belongs_to :chat_user, null: false, comment: "人"
      t.text :message, null: false
      t.timestamps null: false
    end
  end
end
