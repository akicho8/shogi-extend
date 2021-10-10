# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Banana message (kiwi_banana_messages as Kiwi::BananaMessage)
#
# |------------+----------+-------------+-------------+--------------+-------|
# | name       | desc     | type        | opts        | refs         | index |
# |------------+----------+-------------+-------------+--------------+-------|
# | id         | ID       | integer(8)  | NOT NULL PK |              |       |
# | user_id    | User     | integer(8)  | NOT NULL    | => ::User#id | B     |
# | banana_id  | Banana   | integer(8)  | NOT NULL    |              | A! C  |
# | body       | 内容     | string(512) | NOT NULL    |              |       |
# | position   | 順序     | integer(4)  | NOT NULL    |              | A! D  |
# | deleted_at | 削除日時 | datetime    |             |              |       |
# | created_at | 作成日時 | datetime    | NOT NULL    |              |       |
# | updated_at | 更新日時 | datetime    | NOT NULL    |              |       |
# |------------+----------+-------------+-------------+--------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

module Kiwi
  class BananaMessage < ApplicationRecord
    include MessageShared

    belongs_to :banana, counter_cache: true, touch: true

    acts_as_list top_of_list: 1, scope: :banana

    after_create_commit do
      Kiwi::BananaMessageBroadcastJob.perform_later(self)

      # 作者に通知
      if true
        if banana.user != user
          if banana.user.email_valid?
            KiwiMailer.banana_owner_message(self).deliver_later
          end
        end
      end

      # 以前コメントした人たちにも通知
      if true
        member_users.each do |user|
          if user.email_valid?
            KiwiMailer.banana_other_message(user, self).deliver_later
          end
        end
      end

      SlackAgent.message_send(key: "問題コメント", body: [body, banana.page_url].join("\n"))
    end

    # 関係者
    def member_users
      users = banana.banana_message_users # コメントした人たち
      users = users - [user]          # コメントした本人はコメント内容を知っているので送信しない
      users = users - [banana.user]     # 作者にはすでに banana_owner_message で通知しているので(もし居ても)送信しない
      users = users.uniq              # 複数通知しないようにするため
    end
  end
end
