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
    # ユーザー
    create_table :chat_users, force: true do |t|
      t.string :name,                  null: false,              comment: "名前"
      t.belongs_to :current_chat_room, null: true,               comment: "現在入室している部屋"
      t.datetime :online_at,           null: true,               comment: "オンラインになった日時"
      t.datetime :fighting_now_at,     null: true,               comment: "chat_memberships.fighting_now_at と同じでこれを見ると対局中かどうかがすぐにわかる"
      t.datetime :matching_at,         null: true,               comment: "マッチング中(開始日時)"
      t.string :lifetime_key,          null: false, index: true, comment: "ルール・持ち時間"
      t.string :ps_preset_key,         null: false, index: true, comment: "ルール・自分の手合割"
      t.string :po_preset_key,         null: false, index: true, comment: "ルール・相手の手合割"
      t.timestamps null: false
    end

    # 部屋
    create_table :chat_rooms, force: true do |t|
      t.belongs_to :room_owner,                        null: false, comment: "部屋を作った人(とくに利用していなが親メンバーを特定したいときに使う)"
      t.string :preset_key,                            null: false, comment: "手合割"
      t.string :lifetime_key,                          null: false, comment: "時間"
      t.string :name,                                  null: false, comment: "部屋名"
      t.text :kifu_body_sfen,                          null: false, comment: "USI形式棋譜"
      t.text :clock_counts,                            null: false, comment: "対局時計情報"
      t.integer :turn_max,                             null: false, comment: "手番数"
      t.datetime :battle_request_at,                   null: true,  comment: "対局申し込みによる成立日時"
      t.datetime :auto_matched_at,                     null: true,  comment: "自動マッチングによる成立日時"
      t.datetime :begin_at,                     null: true,  comment: "メンバーたち部屋に入って対局開始になった日時"
      t.datetime :end_at,                       null: true,  comment: "バトル終了日時"
      t.string :last_action_key,                       null: true,  comment: "最後の状態"
      t.string :win_location_key,                      null: true,  comment: "勝った方の先後"
      t.integer :current_chat_users_count, default: 0, null: false, comment: "この部屋にいる人数"
      t.integer :watch_memberships_count, default: 0,  null: false, comment: "この部屋の観戦者数"
      t.timestamps null: false
    end

    # 対局者
    create_table :chat_memberships, force: true do |t|
      t.belongs_to :chat_room, null: false,              comment: "部屋"
      t.belongs_to :chat_user, null: false,              comment: "ユーザー"
      t.string :preset_key,    null: false,              comment: "手合割"
      t.string :location_key,  null: false, index: true, comment: "先後"
      t.integer :position,                  index: true, comment: "入室順序"
      t.datetime :standby_at,                            comment: "準備完了日時"
      t.datetime :fighting_now_at,                       comment: "部屋に入った日時で抜けたり切断すると空"
      t.timestamps null: false
    end

    # 観戦者
    create_table :watch_memberships, force: true do |t|
      t.belongs_to :chat_room, null: false, comment: "部屋"
      t.belongs_to :chat_user, null: false, comment: "ユーザー"
      t.timestamps null: false
    end

    # 対局部屋のチャット発言
    create_table :room_chat_messages, force: true do |t|
      t.belongs_to :chat_room, null: false, comment: "部屋"
      t.belongs_to :chat_user, null: false, comment: "ユーザー"
      t.text :message, null: false, comment: "発言"
      t.timestamps null: false
    end

    # ロビーチャット発言
    create_table :lobby_chat_messages, force: true do |t|
      t.belongs_to :chat_user, null: false, comment: "ユーザー"
      t.text :message, null: false, comment: "発言"
      t.timestamps null: false
    end
  end
end
