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
  # has_many :chat_rooms, dependent: :destroy
  has_many :chat_articles, dependent: :destroy
  has_many :chat_memberships, dependent: :destroy
  has_many :chat_rooms, through: :chat_memberships

  def appear
    update!(appearing_on: Time.current)
  end

  def disappear
    update!(appearing_on: nil)
  end

  # def message_link
  #   Rails.application.routes.url_helpers.url_for([:resource_ns1, self, only_path: true])
  # end
  # 
  # def js_attributes
  #   JSON.load(to_json(include: [], methods: [:message_link]))
  # end

  after_commit do
    # ChatArticleBroadcastJob.perform_later(self)
    # App.lobby_vm.chat_rooms = #{}
    # chat_rooms = ChatRoom.order(updated_at: :desc).first(10).to_json(include: [:chat_users], methods: [:show_link])
    # chat_room = to_json(include: [:chat_users], methods: [:show_link])
    ActionCable.server.broadcast("lobby_channel", online_users: ChatUser.where.not(appearing_on: nil))
    # ActionCable.server.broadcast("chat_room_channel_#{1}", chat_article: ChatArticle.first.js_attributes)
  end
end
