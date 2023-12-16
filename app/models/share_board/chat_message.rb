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
      # only: [
      #   :sfen,
      #   :position,
      #   :created_at,
      # ],

      only: [
        :id,
        # :room_id,
        # :user_id,
        :content,
        :performed_at,
        # :created_at,
        # :updated_at,
        # :real_user_id,
        :from_connection_id,
        :primary_emoji,
        # :from_user_name,
        # :from_avatar_path,
      ],

      methods: [
        :message_scope_key,
        :from_user_name,
        :from_avatar_path,
      ],
      # include: {
      #   user: {
      #     only: [
      #       :name,
      #     ],
      #   },
      # },
    }

    custom_belongs_to :message_scope,  ar_model: MessageScope, st_model: MessageScopeInfo, default: "ms_public"

    belongs_to :real_user, class_name: "::User", optional: true # ログインしているユーザーID

    belongs_to :user, counter_cache: true # 発言者
    belongs_to :room, counter_cache: true # 所属する部屋

    normalizes :content, with: -> e { column_value_db_truncate(:content, e) }

    # default_scope { order(:created_at) }

    before_validation do
      self.performed_at ||= (Time.current.to_f * 1000).to_i
      self.content ||= ""
    end

    with_options presence: true do
      validates :performed_at
    end

    def broadcast_to_all
      __nil_check_skip_keys__ = [
        "message_scope_key",
        "from_connection_id",
        "primary_emoji",
        "from_avatar_path",
      ]
      data = as_json(JSON_TYPE1).merge("__nil_check_skip_keys__" => __nil_check_skip_keys__)
      Broadcaster.new(room.key).call("message_share_broadcasted", data)
    end

    # def as_chat_json
    #   as_json(JSON_TYPE1)
    # end

    def from_user_name
      user.name
    end

    # http://localhost:3000/api/share_board/chat_message_loader?room_code=dev_room
    def from_avatar_path
      real_user&.avatar_path
    end

    # def performed_at
    #   created_at.to_i
    # end

    def responder1_job_run
      Responder1Job.perform_later(id)
    end

    def responder1_main_run
      ChatAi::Responder::Responder1.new(self).call
    end

    def responder2_main_run
      ChatAi::Responder::Responder2.new(self).call
    end
  end
end
