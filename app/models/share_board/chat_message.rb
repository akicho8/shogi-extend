# -*- coding: utf-8 -*-

# == Schema Information ==
#
# Chat message (share_board_chat_messages as ShareBoard::ChatMessage)
#
# |--------------------+-----------------+-------------+-------------+--------------+-------|
# | name               | desc            | type        | opts        | refs         | index |
# |--------------------+-----------------+-------------+-------------+--------------+-------|
# | id                 | ID              | integer(8)  | NOT NULL PK |              |       |
# | room_id            | Room            | integer(8)  | NOT NULL    |              | A     |
# | user_id            | User            | integer(8)  | NOT NULL    | => User#id   | B     |
# | message_scope_id   | Message scope   | integer(8)  | NOT NULL    |              | C     |
# | content            | Content         | string(256) | NOT NULL    |              |       |
# | performed_at       | Performed at    | integer(8)  | NOT NULL    |              |       |
# | created_at         | 作成日時        | datetime    | NOT NULL    |              |       |
# | updated_at         | 更新日時        | datetime    | NOT NULL    |              |       |
# | session_user_id    | Session user    | integer(8)  |             | => ::User#id | D     |
# | from_connection_id | From connection | string(255) |             |              |       |
# | primary_emoji      | Primary emoji   | string(255) |             |              |       |
# |--------------------+-----------------+-------------+-------------+--------------+-------|
#
# - Remarks ----------------------------------------------------------------------
# User.has_many :share_board_chat_messages, foreign_key: :session_user_id
# User.has_one :profile
# [Warning: Need to add index] create_share_board_chat_messages マイグレーションに add_index :share_board_chat_messages, :from_connection_id を追加しよう
# [Warning: Need to add relation] ShareBoard::ChatMessage モデルに belongs_to :from_connection を追加しよう
# --------------------------------------------------------------------------------

module ShareBoard
  class ChatMessage < ApplicationRecord
    JSON_TYPE1 = {
      only: [
        :id,
        :content,
        :performed_at,
        :session_user_id,
        :client_token,
        :from_connection_id,
        :primary_emoji,
        :force_talk,
        :user_selected_avatar,
      ],
      methods: [
        :message_scope_key,
        :from_user_name,
        :from_avatar_path,
      ],
    }

    custom_belongs_to :message_scope,  ar_model: MessageScope, st_model: MessageScopeInfo, default: "ms_public"

    belongs_to :session_user, class_name: "::User", optional: true # ログインしているユーザーID

    belongs_to :user, counter_cache: true # 発言者
    belongs_to :room, counter_cache: true # 所属する部屋

    scope :old_only, -> expires_in { where(arel_table[:created_at].lt(expires_in.seconds.ago)) } # 削除対象

    normalizes :content, with: -> e { column_value_db_truncate(:content, e) } # 長すぎるメッセージを途中で切る

    # 仮にソートするなら performed_at を参照すること
    # default_scope { order(:performed_at) }

    before_validation do
      self.performed_at ||= (Time.current.to_f * 1000).to_i
      self.force_talk ||= false
      self.user_selected_avatar ||= ""
      self.client_token ||= ""

      self.content ||= ""
      self.content = StringSupport.user_message_normalize(content)
    end

    with_options presence: true do
      validates :performed_at
    end

    # 配る
    def broadcast_to_all
      data = as_json(JSON_TYPE1).merge("__nil_check_skip_keys__" => __nil_check_skip_keys__)
      Broadcaster.new(room.key).call("message_share_broadcasted", data)
    end

    # 送信者名
    def from_user_name
      user.name
    end

    # ログインしている人のアバター画像
    # http://localhost:3000/api/share_board/chat_message_loader?room_key=dev_room
    def from_avatar_path
      session_user&.avatar_path
    end

    def strip_tagged_content
      StringSupport.strip_tags(content)
    end

    def responder_res_job_run
      ResponderResJob.perform_later(id)
    end

    def responder_res_main_run
      ChatAi::Responder::ResponderRes.new(self).call
    end

    def responder_something_say_main_run
      ChatAi::Responder::ResponderSomethingSay.new(self).call
    end

    # se say -r dev_room -t bot -m GPTです。こんにちは
    def info
      {
        :room_key      => room.key,
        :session_user_name => session_user&.name,
        **attributes,
        **as_json(JSON_TYPE1),
      }
    end

    private

    def __nil_check_skip_keys__
      [
        "message_scope_key",
        "from_connection_id",
        "primary_emoji",
        "from_avatar_path",
        "session_user_id",
      ]
    end
  end
end
