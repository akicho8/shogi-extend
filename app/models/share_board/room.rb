# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Room (share_board_rooms as ShareBoard::Room)
#
# |---------------+---------------+-------------+-------------+------+-------|
# | name          | desc          | type        | opts        | refs | index |
# |---------------+---------------+-------------+-------------+------+-------|
# | id            | ID            | integer(8)  | NOT NULL PK |      |       |
# | key           | キー          | string(255) | NOT NULL    |      | A!    |
# | battles_count | Battles count | integer(4)  | DEFAULT(0)  |      |       |
# | created_at    | 作成日時      | datetime    | NOT NULL    |      |       |
# | updated_at    | 更新日時      | datetime    | NOT NULL    |      |       |
# |---------------+---------------+-------------+-------------+------+-------|

module ShareBoard
  class Room < ApplicationRecord
    class << self
      def fetch(key)
        find_by!(key: key)
      end

      def mock
        room = Room.create!
        room.redis_clear
        room.battles.create! do |e|
          e.memberships.build([
              { user_name: "alice", location_key: "black", judge_key: "win",  },
              { user_name: "bob",   location_key: "white", judge_key: "lose", },
              { user_name: "carol", location_key: "black", judge_key: "win",  },
            ])
        end
        room
      end
    end

    has_many :battles, -> { order(created_at: :desc) }, dependent: :destroy, inverse_of: :room # この部屋の対局履歴たち
    has_many :memberships, through: :battles                                                   # この部屋のユーザー対局履歴たち
    has_many :users, through: :memberships                                                     # この部屋の対局者たち

    has_many :roomships, dependent: :destroy, inverse_of: :room # この部屋の対局者の情報(ランキングとしてそのまま使える)

    before_validation do
      self.key ||= "dev_room"
    end

    with_options presence: true do
      validates :key
    end

    def score_by_user(user)
      memberships.where(user: user, judge: Judge.fetch(:win)).count
    end

    def ox_count_by_user(user, judge)
      memberships.where(user: user, judge: Judge.fetch(judge)).count
    end

    def rank_by_score(score)
      redis.call("ZCOUNT", redis_key, score + 1, "+inf") + 1
    end

    def redis_clear
      redis.call("DEL", redis_key)
    end

    # "share_board/room/1"
    def redis_key
      [self.class.name.underscore, id].join("/")
    end

    def redis_rebuild
      redis_clear
      roomships.each(&:score_post_to_redis)
      roomships.each(&:rank_update)
    end

    def redis
      @redis ||= RedisClient.new(db: AppConfig[:redis_db_for_share_board_room])
    end
  end
end
