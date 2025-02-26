# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Xmode (swars_xmodes as Swars::Xmode)
#
# |------------+----------+-------------+-------------+------+-------|
# | name       | desc     | type        | opts        | refs | index |
# |------------+----------+-------------+-------------+------+-------|
# | id         | ID       | integer(8)  | NOT NULL PK |      |       |
# | key        | キー     | string(255) | NOT NULL    |      | A!    |
# | position   | 順序     | integer(4)  |             |      | B     |
# | created_at | 作成日時 | datetime    | NOT NULL    |      |       |
# | updated_at | 更新日時 | datetime    | NOT NULL    |      |       |
# |------------+----------+-------------+-------------+------+-------|

require "rails_helper"

module Swars
  RSpec.describe Imode, type: :model, swars_spec: true do
    it "name" do
      assert { Imode.fetch("通常").name == "通常" }
      assert { Imode.fetch("スプリント").name == "スプリント" }
    end

    it "relation" do
      imode = Imode.fetch("スプリント")
      user1 = User.create!(user_key: "user1")
      user2 = User.create!(user_key: "user2")
      battle = Battle.create_with_members!([user1, user2], imode: imode)
      assert { battle.imode == imode }

      assert { imode.battles == [battle] }
      assert { imode.memberships == battle.memberships }
    end
  end
end
