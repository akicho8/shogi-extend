# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 件名と本文のみテーブル (room_chat_messages as RoomChatMessage)
#
# +------------+----------+----------+-------------+------+-------+
# | カラム名   | 意味     | タイプ   | 属性        | 参照 | INDEX |
# +------------+----------+----------+-------------+------+-------+
# | id         | ID       | integer  | NOT NULL PK |      |       |
# | subject    | 件名     | string   |             |      |       |
# | body       | 内容     | text     |             |      |       |
# | created_at | 作成日時 | datetime | NOT NULL    |      |       |
# | updated_at | 更新日時 | datetime | NOT NULL    |      |       |
# +------------+----------+----------+-------------+------+-------+

class CreateRoomChatMessages < ActiveRecord::Migration[5.1]
  def up
    create_table :chat_users, force: true do |t|
      t.string :name, null: false
      t.belongs_to :current_chat_room
      t.datetime :online_at
      t.datetime :fighting_now_at, comment: "chat_memberships.fighting_now_at と同じでこれを見ると対局中かどうかがすぐにわかる"
      t.datetime :matching_at
      t.string :lifetime_key
      t.string :ps_preset_key
      t.string :po_preset_key
      t.timestamps null: false
    end
    create_table :chat_rooms, force: true do |t|
      t.belongs_to :room_owner,                        null: false
      t.string :preset_key,                            null: false
      t.string :lifetime_key,                          null: false
      t.string :name,                                  null: false
      t.text :kifu_body_sfen,                          null: false
      t.text :clock_counts,                            null: false
      t.integer :turn_max,                             null: false
      t.datetime :auto_matched_at
      t.datetime :battle_begin_at
      t.datetime :battle_end_at
      t.string :win_location_key
      t.string :give_up_location_key
      t.timestamps                                     null: false
      t.integer :current_chat_users_count, default: 0, null: false
      t.integer :kansen_memberships_count, default: 0, null: false
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
    create_table :kansen_memberships, force: true do |t|
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
