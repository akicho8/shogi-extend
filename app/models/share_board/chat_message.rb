# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Roomship (share_board_roomships as ShareBoard::Roomship)
#
# |---------------+---------------+------------+-------------+------------+-------|
# | name          | desc          | type       | opts        | refs       | index |
# |---------------+---------------+------------+-------------+------------+-------|
# | id            | ID            | integer(8) | NOT NULL PK |            |       |
# | room_id       | Room          | integer(8) | NOT NULL    |            | A     |
# | user_id       | User          | integer(8) | NOT NULL    | => User#id | B     |
# | win_count     | Win count     | integer(4) | NOT NULL    |            | C     |
# | lose_count    | Lose count    | integer(4) | NOT NULL    |            | D     |
# | battles_count | Battles count | integer(4) | NOT NULL    |            |       |
# | win_rate      | Win rate      | float(24)  | NOT NULL    |            | E     |
# | score         | Score         | integer(4) | NOT NULL    |            | F     |
# | rank          | Rank          | integer(4) | NOT NULL    |            | G     |
# | created_at    | 作成日時      | datetime   | NOT NULL    |            |       |
# | updated_at    | 更新日時      | datetime   | NOT NULL    |            |       |
# |---------------+---------------+------------+-------------+------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

module ShareBoard
  class ChatMessage < ApplicationRecord
    JSON_TYPE1 = {
      only: [
        :id,
        :content,
        :performed_at,
        :real_user_id,
        :from_connection_id,
        :primary_emoji,
      ],
      methods: [
        :message_scope_key,
        :from_user_name,
        :from_avatar_path,
      ],
    }

    custom_belongs_to :message_scope,  ar_model: MessageScope, st_model: MessageScopeInfo, default: "ms_public"

    belongs_to :real_user, class_name: "::User", optional: true # ログインしているユーザーID

    belongs_to :user, counter_cache: true # 発言者
    belongs_to :room, counter_cache: true # 所属する部屋

    normalizes :content, with: -> e { column_value_db_truncate(:content, e) } # 長すぎるメッセージを途中で切る

    # 仮にソートするなら performed_at を参照すること
    # default_scope { order(:performed_at) }

    before_validation do
      self.performed_at ||= (Time.current.to_f * 1000).to_i
      self.content ||= ""
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
    # http://localhost:3000/api/share_board/chat_message_loader?room_code=dev_room
    def from_avatar_path
      real_user&.avatar_path
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
        :room_code      => room.key,
        :real_user_name => real_user&.name,
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
        "real_user_id",
      ]
    end
  end
end
