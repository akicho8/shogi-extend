# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Room (actf_rooms as Actf::Room)
#
# |------------+-----------+-------------+-------------+------+-------|
# | name       | desc      | type        | opts        | refs | index |
# |------------+-----------+-------------+-------------+------+-------|
# | id         | ID        | integer(8)  | NOT NULL PK |      |       |
# | begin_at   | Begin at  | datetime    | NOT NULL    |      | A     |
# | end_at     | End at    | datetime    |             |      | B     |
# | final_key  | Final key | string(255) |             |      | C     |
# | created_at | 作成日時  | datetime    | NOT NULL    |      |       |
# | updated_at | 更新日時  | datetime    | NOT NULL    |      |       |
# |------------+-----------+-------------+-------------+------+-------|

# user1 = Colosseum::User.create!
# user2 = Colosseum::User.create!
#
# room = Actf::Room.create! do |e|
#   e.memberships.build(user: user1, judge_key: "win")
#   e.memberships.build(user: user2, judge_key: "lose")
# end
#
# room.messages.create!(user: user1, body: "a") # => #<Actf::Message id: 1, user_id: 31, room_id: 18, body: "a", created_at: "2020-05-05 07:18:46", updated_at: "2020-05-05 07:18:46">
#
module Actf
  class Room < ApplicationRecord
    has_many :messages, dependent: :destroy
    has_many :memberships, dependent: :destroy

    before_validation do
      self.begin_at ||= Time.current
      if final_key
        self.end_at ||= Time.current
      end
    end

    with_options presence: true do
      validates :begin_at
    end

    after_create_commit do
      Actf::LobbyBroadcastJob.perform_later(self)
    end

    def simple_quest_infos
      # QuestInfo.collect { |e| {
      #     init_sfen: e[:init_sfen],
      #     moves_answers: e[:moves_answers]
      #   }
      # }

      Question.limit(3).as_json(include: [:user, :moves_answers]) # FIXME: 必要なのだけに絞る
    end

    def final_info
      FinalInfo.fetch_if(final_key)
    end
  end
end
