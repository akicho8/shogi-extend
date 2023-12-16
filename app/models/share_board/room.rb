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

    has_many :chot_messages, dependent: :destroy do                # この部屋の発言
      def create_from_data!(data)
        data = data.symbolize_keys
        user = User.find_or_create_by!(name: data[:from_user_name])
        create!({
                  :user               => user,
                  :content            => data[:message],
                  :message_scope_key  => data[:message_scope_key],
                  :from_connection_id => data[:from_connection_id],
                  :real_user_id       => data[:real_user_id],
                  # :from_avatar_path   => data[:from_avatar_path], # とる
                  :primary_emoji      => data[:primary_emoji],
                  :performed_at       => data[:performed_at],
                })
      end
    end
    has_many :chot_users, through: :chot_messages, source: :user # この部屋の発言者たち

    before_validation do
      if Rails.env.development?
        self.key ||= SecureRandom.hex
      end
      if Rails.env.test?
        self.key ||= "dev_room"
      end
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

    def receive_and_bc(data)
      # data = {
      #   "from_connection_id"=>"Ea29TwGfUbD",
      #   "from_user_name"=>"alice",
      #   "performed_at"=>1702177627002,
      #   "ua_icon_key"=>"mac",
      #   "ac_events_hash"=>{"initialized"=>1},
      #   "debug_mode_p"=>true,
      #   "from_avatar_path"=>"/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBEQT09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--76b7d01ef121c14889a810397668c90660fc3585/mcA_BLhf_normal.png",
      #   "message_scope_key"=>"ms_public",
      #   "message"=>"jkjk",
      #   "action"=>"message_share",
      # }

      # user = User.find_or_create_by!(name: data["from_user_name"])
      # chot_message = chot_messages.create!(user: user, content: data["message"])
      # chot_messages.create_from_data!(data)

      # chot_message = Room.find_or_create_by!(key: room_code).chot_messages.create_from_data!(data)
      chot_message = chot_messages.create_from_data!(data) # DBに入れる
      chot_message.broadcast_to_all                          # バックグラウンドで配る
      ShareBoard::Responder1Job.perform_later(data.merge(room_code: room_code)) # バックグラウンドで返事をする FIXME: chot_message を元にする？
      # chot_message.responder1_job_run
    end

    def as_json_for_chot_message_loader(params = {})
      ChotMessageLoader.new(self, params).as_json
    end

    def chot_messages_mock_setup(n = 10, user: nil)
      if Rails.env.local?
        if chot_messages.empty?
          user ||= User.create!
          chot_messages.destroy_all
          n.times do |i|
            chot_messages.create!(user: user, content: "(#{i})")
          end
        end
      end
    end
  end
end
