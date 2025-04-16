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
# - Remarks ---------------------------------------------------------------------
# Judge.has_many :swars_memberships
# Location.has_many :swars_memberships
# User.has_one :profile
# -------------------------------------------------------------------------------

# == ShareBoard::Schema ShareBoard::Information ==
#
# ShareBoard::Membership (share_board_memberships as ShareBoard::Membership)
#
# |-------------+----------+------------+-------------+----------------+-------|
# | name        | desc     | type       | opts        | refs           | index |
# |-------------+----------+------------+-------------+----------------+-------|
# | id          | ID       | integer(8) | NOT NULL PK |                |       |
# | battle_id   | ShareBoard::Battle   | integer(8) | NOT NULL    |                | A     |
# | user_id     | ShareBoard::User     | integer(8) | NOT NULL    | => ShareBoard::User#id     | B     |
# | judge_id    | ShareBoard::Judge    | integer(8) | NOT NULL    | => ShareBoard::Judge#id    | C     |
# | location_id | ShareBoard::Location | integer(8) | NOT NULL    | => ShareBoard::Location#id | D     |
# | position    | 順序     | integer(4) |             |                | E     |
# | created_at  | 作成日時 | datetime   | NOT NULL    |                |       |
# | updated_at  | 更新日時 | datetime   | NOT NULL    |                |       |
# |-------------+----------+------------+-------------+----------------+-------|
#
#- ShareBoard::Remarks ----------------------------------------------------------------------
# ShareBoard::Judge.has_many :swars_memberships
# ShareBoard::Location.has_many :swars_memberships
# ShareBoard::User.has_one :profile
#--------------------------------------------------------------------------------

require "rails_helper"

RSpec.describe ShareBoard::Membership do
  it "user_id は battle_id 内で固有であるバリデーションが効いている" do
    room = ShareBoard::Room.create!
    battle = room.battles.create!
    membership = battle.memberships.create(user_name: "alice", location_key: "black", judge_key: "lose")
    membership = battle.memberships.create(user_name: "alice", location_key: "black", judge_key: "lose")
    assert { membership.errors[:user_id] }
  end
end
