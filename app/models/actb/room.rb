# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Room (actb_rooms as Actb::Room)
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
# |---------------+---------------+------------+---------------------+------+-------|

# user1 = User.create!
# user2 = User.create!
#
# battle = Actb::Room.create! do |e|
#   e.memberships.build(user: use)
#   e.memberships.build(user: use)
# end
#
module Actb
  class Room < ApplicationRecord
    class << self
      def create_with_members!(users, attributes = {})
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

    before_validation do
      self.begin_at ||= Time.current
      self.rule ||= Rule.fetch(:marathon_rule)
    end

    with_options presence: true do
      validates :begin_at
    end

    after_create_commit do
      Actb::RoomBroadcastJob.perform_later(self)
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
          only: [:id],
          include: {
            memberships: {
              only: [:id],
              include: {
                user: {
                  only: [:id, :name], methods: [:avatar_path],
                  include: {
                    actb_setting: {
                      only: [
                        :session_lock_token,
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
