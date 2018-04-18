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

class ChatRoom < ApplicationRecord
  has_many :chat_articles, dependent: :destroy
  has_many :chat_memberships, dependent: :destroy
  has_many :chat_users, through: :chat_memberships

  before_validation on: :create do
    self.name = name.presence || name_default
    self.kifu_body_sfen ||= "position startpos"
  end

  def name_default
    "対戦ルーム ##{ChatRoom.count.next}"
  end

  def human_kifu_text_get
    info = Warabi::Parser.parse(kifu_body_sfen, typical_error_case: :embed)
    begin
      mediator = info.mediator
    rescue => error
      return error.message
    end
    mediator.to_ki2_a.join(" ")
  end

  def show_link
    Rails.application.routes.url_helpers.url_for([:resource_ns1, self, only_path: true])
  end

  def js_attributes
    JSON.load(to_json(include: [:chat_users], methods: [:show_link]))
  end

  after_create_commit do
    # ChatArticleBroadcastJob.perform_later(self)
    # App.appearance_vm.chat_rooms = #{}
    # chat_rooms = ChatRoom.order(updated_at: :desc).first(10).to_json(include: [:chat_users], methods: [:show_link])
    # chat_room = to_json(include: [:chat_users], methods: [:show_link])

    ActionCable.server.broadcast("appearance_channel", chat_room: js_attributes)
    # ActionCable.server.broadcast("chat_room_channel_#{1}", chat_article: ChatArticle.first.js_attributes)
  end
end
