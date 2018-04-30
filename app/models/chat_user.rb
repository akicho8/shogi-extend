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

class ChatUser < ApplicationRecord
  has_many :chat_articles, dependent: :destroy
  has_many :chat_memberships, dependent: :destroy
  has_many :chat_rooms, through: :chat_memberships
  has_many :owner_rooms, class_name: "ChatRoom", foreign_key: :room_owner_id, dependent: :destroy, inverse_of: :room_owner

  before_validation on: :create do
    self.name ||= "野良#{ChatUser.count.next}号"
  end

  def appear
    update!(appearing_at: Time.current)
  end

  def disappear
    update!(appearing_at: nil)
  end

  after_commit do
    ActionCable.server.broadcast("lobby_channel", online_users: ChatUser.where.not(appearing_at: nil))
    ActionCable.server.broadcast("system_notification_channel", {active_user_count: ChatUser.where.not(appearing_at: nil).count})
  end
end
