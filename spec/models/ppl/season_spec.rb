# -*- coding: utf-8 -*-

# == Schema Information ==
#
# League season (ppl_seasons as Ppl::Season)
#
# |------------+----------+-------------+-------------+------+-------|
# | name       | desc     | type        | opts        | refs | index |
# |------------+----------+-------------+-------------+------+-------|
# | id         | ID       | integer(8)  | NOT NULL PK |      |       |
# | key        | キー     | string(255) | NOT NULL    |      | A     |
# | position   | 順序     | integer(4)  |             |      | B     |
# | created_at | 作成日時 | datetime    | NOT NULL    |      |       |
# | updated_at | 更新日時 | datetime    | NOT NULL    |      |       |
# |------------+----------+-------------+-------------+------+-------|

require "rails_helper"

RSpec.describe Ppl::Season, type: :model do
  it "works" do
    Ppl.setup_for_workbench
    Ppl::SeasonKeyVo["5"].users_update({ name: "alice" })
    assert { Ppl::User["alice"].seasons.sole.key == Ppl::SeasonKeyVo["5"] }
  end

  it "#latest_or_base_key" do
    Ppl.setup_for_workbench
    assert { Ppl::Season.latest_or_base_key.name == "S31前" }
    Ppl::SeasonKeyVo["1"].find_or_create
    assert { Ppl::Season.latest_or_base_key.name == "1" }
  end
end
