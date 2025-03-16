# -*- coding: utf-8 -*-
# == Tsl::Schema Tsl::Information ==
#
# Tsl::Membership (tsl_memberships as Tsl::Membership)
#
# |--------------------------+--------------------------+-------------+-------------+------------+-------|
# | name                     | desc                     | type        | opts        | refs       | index |
# |--------------------------+--------------------------+-------------+-------------+------------+-------|
# | id                       | ID                       | integer(8)  | NOT NULL PK |            |       |
# | league_id                | Tsl::League                   | integer(8)  | NOT NULL    |            | A! B  |
# | user_id                  | Tsl::User                     | integer(8)  | NOT NULL    | => Tsl::User#id | A! C  |
# | result_key               | Tsl::Result key               | string(255) | NOT NULL    |            | D     |
# | start_pos                | Tsl::Start pos                | integer(4)  | NOT NULL    |            | E     |
# | age                      | Tsl::Age                      | integer(4)  |             |            |       |
# | win                      | Tsl::Win                      | integer(4)  |             |            | F     |
# | lose                     | Tsl::Lose                     | integer(4)  |             |            | G     |
# | ox                       | Ox                       | string(255) | NOT NULL    |            |       |
# | previous_runner_up_count | Tsl::Previous runner up count | integer(4)  | NOT NULL    |            | H     |
# | seat_count               | Tsl::Seat count               | integer(4)  | NOT NULL    |            |       |
# | created_at               | 作成日時                 | datetime    | NOT NULL    |            |       |
# | updated_at               | 更新日時                 | datetime    | NOT NULL    |            |       |
# |--------------------------+--------------------------+-------------+-------------+------------+-------|
#
#- Tsl::Remarks ----------------------------------------------------------------------
# Tsl::User.has_one :profile
#--------------------------------------------------------------------------------

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
