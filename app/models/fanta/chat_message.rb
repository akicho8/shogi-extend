# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Chat messageテーブル (chat_messages as Fanta::ChatMessage)
#
# |----------------+-------------+-------------+-------------+------------------+-------|
# | カラム名       | 意味        | タイプ      | 属性        | 参照             | INDEX |
# |----------------+-------------+-------------+-------------+------------------+-------|
# | id             | ID          | integer(8)  | NOT NULL PK |                  |       |
# | battle_id | Battle room | integer(8)  | NOT NULL    | => Fanta::Battle#id | A     |
# | user_id        | Fanta::User        | integer(8)  | NOT NULL    | => Fanta::User#id       | B     |
# | message        | Message     | text(65535) | NOT NULL    |                  |       |
# | created_at     | 作成日時    | datetime    | NOT NULL    |                  |       |
# | updated_at     | 更新日時    | datetime    | NOT NULL    |                  |       |
# |----------------+-------------+-------------+-------------+------------------+-------|
#
#- 備考 -------------------------------------------------------------------------
# ・Fanta::ChatMessage モデルは Fanta::Battle モデルから has_many :memberships されています。
# ・Fanta::ChatMessage モデルは Fanta::User モデルから has_many :chat_messages されています。
#--------------------------------------------------------------------------------

class Fanta::ChatMessage < ApplicationRecord
  belongs_to :user
  belongs_to :battle

  scope :latest_list, -> { order(:created_at) } # チャットルームに表示する最新N件

  # 非同期にするため
  # after_create_commit do
  #   ChatMessageBroadcastJob.perform_later(self)
  # end
end
