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

class RoomChatMessage < ApplicationRecord
  belongs_to :chat_user
  belongs_to :chat_room

  # 非同期にするため
  after_create_commit do
    RoomChatMessageBroadcastJob.perform_later(self)
  end

  def js_attributes
    JSON.load(to_json(include: [:chat_user, :chat_room]))
  end
end
