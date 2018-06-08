# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Lobby messageテーブル (lobby_messages as LobbyMessage)
#
# |------------+----------+-------------+-------------+------------+-------|
# | カラム名   | 意味     | タイプ      | 属性        | 参照       | INDEX |
# |------------+----------+-------------+-------------+------------+-------|
# | id         | ID       | integer(8)  | NOT NULL PK |            |       |
# | user_id    | User     | integer(8)  | NOT NULL    | => User#id | A     |
# | message    | Message  | text(65535) | NOT NULL    |            |       |
# | created_at | 作成日時 | datetime    | NOT NULL    |            |       |
# | updated_at | 更新日時 | datetime    | NOT NULL    |            |       |
# |------------+----------+-------------+-------------+------------+-------|
#
#- 備考 -------------------------------------------------------------------------
# ・LobbyMessage モデルは User モデルから has_many :chat_messages されています。
#--------------------------------------------------------------------------------

class LobbyMessage < ApplicationRecord
  belongs_to :user

  cattr_accessor(:chat_window_size) { 10 }

  scope :latest_list, -> { order(created_at: :desc).limit(chat_window_size) } # 実際に使うときは昇順表示なので reverse しよう

  # # 非同期にするため
  # after_create_commit do
  #   ChatMessageBroadcastJob.perform_later(self)
  # end
end
