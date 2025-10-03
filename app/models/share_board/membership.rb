# -*- coding: utf-8 -*-

# == Schema Information ==
#
# Membership (share_board_memberships as ShareBoard::Membership)
#
# |-------------+----------+------------+-------------+----------------+-------|
# | name        | desc     | type       | opts        | refs           | index |
# |-------------+----------+------------+-------------+----------------+-------|
# | id          | ID       | integer(8) | NOT NULL PK |                |       |
# | battle_id   | Battle   | integer(8) | NOT NULL    |                | A     |
# | user_id     | User     | integer(8) | NOT NULL    | => User#id     | B     |
# | judge_id    | Judge    | integer(8) | NOT NULL    | => Judge#id    | C     |
# | location_id | Location | integer(8) | NOT NULL    | => Location#id | D     |
# | position    | 順序     | integer(4) |             |                | E     |
# | created_at  | 作成日時 | datetime   | NOT NULL    |                |       |
# | updated_at  | 更新日時 | datetime   | NOT NULL    |                |       |
# |-------------+----------+------------+-------------+----------------+-------|
#
# - Remarks ----------------------------------------------------------------------
# Judge.has_many :swars_memberships
# Location.has_many :swars_memberships
# User.has_one :profile
# --------------------------------------------------------------------------------

module ShareBoard
  class Membership < ApplicationRecord
    custom_belongs_to :location, ar_model: Location, st_model: LocationInfo, default: nil
    custom_belongs_to :judge,    ar_model: Judge,    st_model: JudgeInfo,    default: nil

    belongs_to :battle                                 # 対局
    belongs_to :user, touch: true, counter_cache: true # 対局者
    has_one :room, through: :battle                    # 部屋

    scope :position_order, -> { order(:position) }

    acts_as_list top_of_list: 0, scope: :battle

    # https://github.com/rails/rails/issues/50173
    with_options allow_blank: true do
      validates :user_id, uniqueness: { scope: :battle_id }
    end

    after_create :zadd_call

    def user_name=(name)
      self.user = User.find_or_initialize_by(name: name)
    end

    def zadd_call
      roomship = Roomship.find_or_initialize_by(room: room, user: user)
      roomship.win_count = room.ox_count_by_user(user, :win)
      roomship.lose_count = room.ox_count_by_user(user, :lose)
      roomship.save!
    end
  end
end
