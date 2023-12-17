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

# dev_room に Bot ユーザーが 🍄 GPT の名前で観戦者宛として発言する
#
#  room = ShareBoard::Room.find_or_create_by!(key: "dev_room")
#  room.receive_and_bc({
#                        "from_user_name"    => "GPT",
#                        "content"           => "(content)",
#                        "real_user_id"      => User.bot.id,
#                        "message_scope_key" => "ms_private",
#                        "primary_emoji"     => "🍄",
#                      })

module ShareBoard
  class Room < ApplicationRecord
    class << self
      def fetch(key)
        find_or_create_by!(key: key)
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

    has_many :chat_messages, dependent: :destroy do                # この部屋の発言
      def create_from_data!(data)
        data = data.symbolize_keys
        user = User.fetch(data[:from_user_name])
        create!({
                  :user               => user,
                  :content            => data[:content],
                  :message_scope_key  => data[:message_scope_key],
                  :from_connection_id => data[:from_connection_id], # FIXME: とる
                  :real_user_id       => data[:real_user_id],
                  # :from_avatar_path   => data[:from_avatar_path], # とる
                  :primary_emoji      => data[:primary_emoji],
                  :performed_at       => data[:performed_at],
                })
      end
    end
    has_many :chat_users, through: :chat_messages, source: :user # この部屋の発言者たち

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

    concerning :RankingMethods do
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

    concerning :ChatMesssageMethods do
      class_methods do
        # 発言する
        def simple_say(params = {})
          tp params if Rails.env.development?
          fetch(params[:room_key] || "dev_room").simple_say(params)
        end

        # GPTに発言させる
        def something_say(params = {})
          tp params if Rails.env.development?
          ResponderSomethingSayJob.perform_later(params)
        end
      end

      def simple_say(params = {})
        default_options = {}
        if v = params[:sender_key]
          default_options = SenderInfo.fetch(v).default_options_fn.call
        end
        params = {
          **default_options,
          # :content           => "(content#{chat_messages.count.next})",
          # :real_user_id      => ::User.bot.id,
          # :message_scope_key => "ms_private", # ms_public or ms_private
          # :from_user_name    => "GPT",
          # :primary_emoji     => "🍄",
        }.merge(params.to_options)
        receive_and_bc(params)
      end

      # def gpt_message_send(params = {})
      #   receive_and_bc({
      #                    :content => "(content#{chat_messages.count.next})",
      #                    # :real_user_id      => ::User.bot.id,
      #                    # :message_scope_key => "ms_private", # ms_public or ms_private
      #                    # :from_user_name    => "GPT",
      #                    # :primary_emoji     => "🍄",
      #                  }.merge(params.to_options))
      # end

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
        #   "content"=>"jkjk",
        #   "action"=>"message_share",
        # }

        # user = User.find_or_create_by!(name: data["from_user_name"])
        # chat_message = chat_messages.create!(user: user, content: data["content"])
        # chat_messages.create_from_data!(data)

        # chat_message = Room.find_or_create_by!(key: room_key).chat_messages.create_from_data!(data)
        chat_message = chat_messages.create_from_data!(data) # DBに入れる
        chat_message.broadcast_to_all                          # バックグラウンドで配る
        ShareBoard::ResponderResJob.perform_later(data.merge(room_key: key)) # バックグラウンドで返事をする FIXME: chat_message を元にする？
        # chat_message.responder_res_job_run
        if Rails.env.development?
          tp chat_message.info
        end
      end

      def as_json_for_chat_message_loader(params = {})
        ChatMessageLoader.new(self, params).as_json
      end

      def chat_messages_mock_setup(n = 10, user: nil)
        if Rails.env.local?
          if chat_messages.empty?
            user ||= User.create!
            chat_messages.destroy_all
            n.times do |i|
              chat_messages.create!(user: user, content: "(#{i})")
            end
          end
        end
      end
    end
  end
end
