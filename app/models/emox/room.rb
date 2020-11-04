# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Room (emox_rooms as Emox::Room)
#
# |---------------+---------------+------------+---------------------+------+-------|
# | name          | desc          | type       | opts                | refs | index |
# |---------------+---------------+------------+---------------------+------+-------|
# | id            | ID            | integer(8) | NOT NULL PK         |      |       |
# | begin_at      | Begin at      | datetime   | NOT NULL            |      | A     |
# | end_at        | End at        | datetime   |                     |      | B     |
# | rule_id       | Rule          | integer(8) | NOT NULL            |      | C     |
# | created_at    | 作成日時      | datetime   | NOT NULL            |      |       |
# | updated_at    | 更新日時      | datetime   | NOT NULL            |      |       |
# | battles_count | Battles count | integer(4) | DEFAULT(0) NOT NULL |      | D     |
# | practice      | Practice      | boolean    |                     |      |       |
# | bot_user_id   | Bot user      | integer(8) |                     |      | E     |
# |---------------+---------------+------------+---------------------+------+-------|

# user1 = User.create!
# user2 = User.create!
#
# battle = Emox::Room.create! do |e|
#   e.memberships.build(user: use)
#   e.memberships.build(user: use)
# end
#
module Emox
  class Room < ApplicationRecord
    class << self
      def create_with_members!(users, attributes = {})
        users.each { |e| Rule.matching_users_delete_from_all_rules(e) }

        create!(attributes) do |e|
          users.each do |user|
            e.memberships.build(user: user)
          end
        end
      end
    end

    has_many :battles, dependent: :destroy
    has_many :messages, class_name: "RoomMessage", dependent: :destroy
    has_many :memberships, -> { order(:position) }, class_name: "RoomMembership", dependent: :destroy, inverse_of: :room
    has_many :users, through: :memberships
    belongs_to :rule
    belongs_to :bot_user, class_name: "User", optional: true

    has_many :histories, dependent: :destroy do
      def without_bot
        where.not(user: proxy_association.owner.bot_user)
      end
    end

    before_validation do
      self.begin_at ||= Time.current
      self.rule ||= Rule.fetch(RuleInfo.default_key)
      self.practice ||= false
    end

    with_options presence: true do
      validates :begin_at
    end

    after_create do
      if bot_user
        if memberships.collect(&:user).exclude?(bot_user)
          raise "BOTが指定されたのにメンバーに含まれていない"
        end
        if memberships[Config[:leader_index]].user == bot_user
          raise "BOTがリーダーになると進行できない"
        end
      end
    end
    after_create_commit do
      Emox::RoomBroadcastJob.perform_later(self)
    end

    def battle_create_with_members!(attributes = {})
      battles.create!(attributes) do |e|
        users.each do |user|
          e.memberships.build(user: user)
        end
      end
    end

    def as_json_type4
      as_json({
          only: [:id, :practice, :bot_user_id],
          include: {
            rule: { only: [:key] },
            memberships: {
              only: [:id],
              include: {
                user: {
                  only: [:id, :name], methods: [:avatar_path],
                  include: {
                    emox_setting: {
                      only: [
                        :session_lock_token, # 別ブラウザでアクセスした自分が受けとらないようにする
                      ]
                    },
                  },
                },
              },
            },
          },
        })
    end
  end
end
