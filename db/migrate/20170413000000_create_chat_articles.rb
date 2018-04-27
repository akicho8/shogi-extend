# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 件名と本文のみテーブル (chat_articles as ChatArticle)
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

class CreateChatArticles < ActiveRecord::Migration[5.1]
  def up
    create_table :chat_users, force: true do |t|
      t.string :name, null: false
      t.datetime :appearing_on
      t.timestamps null: false
    end
    create_table :chat_rooms, force: true do |t|
      t.belongs_to :room_owner, null: false
      t.string :preset_key, null: false
      t.string :name, null: false
      t.text :kifu_body_sfen, null: false
      t.timestamps null: false
    end
    create_table :chat_memberships, force: true do |t|
      t.belongs_to :chat_room, null: false
      t.belongs_to :chat_user, null: false
      t.timestamps null: false
    end
    create_table :chat_articles, force: true do |t|
      t.belongs_to :chat_room, null: false, comment: "部屋"
      t.belongs_to :chat_user, null: false, comment: "人"
      t.text :message, null: false
      t.timestamps null: false
    end
  end
end
