# -*- coding: utf-8 -*-

# == Schema Information ==
#
# Membership (tsl_memberships as Tsl::Membership)
#
# |--------------------------+--------------------------+-------------+-------------+------------+-------|
# | name                     | desc                     | type        | opts        | refs       | index |
# |--------------------------+--------------------------+-------------+-------------+------------+-------|
# | id                       | ID                       | integer(8)  | NOT NULL PK |            |       |
# | league_id                | League                   | integer(8)  | NOT NULL    |            | A! B  |
# | user_id                  | User                     | integer(8)  | NOT NULL    | => User#id | A! C  |
# | result_key               | Result key               | string(255) | NOT NULL    |            | D     |
# | start_pos                | Start pos                | integer(4)  | NOT NULL    |            | E     |
# | age                      | Age                      | integer(4)  |             |            |       |
# | win                      | Win                      | integer(4)  |             |            | F     |
# | lose                     | Lose                     | integer(4)  |             |            | G     |
# | ox                       | Ox                       | string(255) | NOT NULL    |            |       |
# | previous_runner_up_count | Previous runner up count | integer(4)  | NOT NULL    |            | H     |
# | seat_count               | Seat count               | integer(4)  | NOT NULL    |            |       |
# | created_at               | 作成日時                 | datetime    | NOT NULL    |            |       |
# | updated_at               | 更新日時                 | datetime    | NOT NULL    |            |       |
# |--------------------------+--------------------------+-------------+-------------+------------+-------|
#
# - Remarks ----------------------------------------------------------------------
# User.has_one :profile
# --------------------------------------------------------------------------------

require "rails_helper"

RSpec.describe Tsl::Membership, type: :model do
  before do
    Tsl.setup
  end

  let :record do
    Tsl::Membership.first
  end

  it "works" do
    assert { record.valid? }
  end
end
