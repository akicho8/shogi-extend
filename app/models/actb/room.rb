# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Room (actb_rooms as Actb::Room)
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
# room = Room.create! do |e|
#   e.memberships.build(user: user1, judge_key: "win")
#   e.memberships.build(user: user2, judge_key: "lose")
# end
#
# room.room_messages.create!(user: user1, body: "a") # => #<RoomMessage id: 1, user_id: 31, room_id: 18, body: "a", created_at: "2020-05-05 07:18:46", updated_at: "2020-05-05 07:18:46">
#
module Actb
  class Room < ApplicationRecord
    has_many :messages, class_name: "RoomMessage", dependent: :destroy
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
      RoomBroadcastJob.perform_later(self)
    end

    def simple_quest_infos
      # QuestInfo.collect { |e| {
      #     init_sfen: e[:init_sfen],
      #     moves_answers: e[:moves_answers]
      #   }
      # }

      if Rails.env.development?
        n = 2
      else
        n = 5
      end
      ids = Question.where(display_key: :public).ids.sample(n)
      Question.where(id: ids).order(:difficulty_level).as_json(only: [:id, :init_sfen, :time_limit_sec, :difficulty_level, :title, :description, :hint_description, :source_desc, :other_twitter_account], include: {:user => { only: [:id, :name, :key], methods: [:avatar_path] }, :moves_answers => {only: [:limit_turn, :moves_str, :end_sfen]}})
    end

    def final_info
      FinalInfo.fetch_if(final_key)
    end
  end
end
