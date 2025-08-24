# -*- coding: utf-8 -*-

# == Schema Information ==
#
# Membership (ppl_memberships as Ppl::Membership)
#
# |------------------+---------------+-------------+-------------+------------+-------|
# | name             | desc          | type        | opts        | refs       | index |
# |------------------+---------------+-------------+-------------+------------+-------|
# | id               | ID            | integer(8)  | NOT NULL PK |            |       |
# | season_id | League season | integer(8)  | NOT NULL    |            | A! B  |
# | user_id          | User          | integer(8)  | NOT NULL    | => User#id | A! C  |
# | result_id        | Result        | integer(8)  | NOT NULL    |            | D     |
# | age              | Age           | integer(4)  |             |            |       |
# | win              | Win           | integer(4)  | NOT NULL    |            | E     |
# | lose             | Lose          | integer(4)  | NOT NULL    |            |       |
# | ox               | Ox            | string(255) | NOT NULL    |            |       |
# | created_at       | 作成日時      | datetime    | NOT NULL    |            |       |
# | updated_at       | 更新日時      | datetime    | NOT NULL    |            |       |
# |------------------+---------------+-------------+-------------+------------+-------|
#
# - Remarks ----------------------------------------------------------------------
# User.has_one :profile
# --------------------------------------------------------------------------------

require "rails_helper"

RSpec.describe Ppl::Membership, type: :model do
  it "works" do
    Ppl.setup_for_workbench
    Ppl::SeasonKeyVo["5"].update_by_records({ name: "alice", result_key: "維持", age: 1, win: 3 })
    membership = Ppl::User["alice"].memberships.sole
    assert { membership.result_info.name == "維持" }
  end
end
