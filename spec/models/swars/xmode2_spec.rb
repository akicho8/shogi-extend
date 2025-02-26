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
  RSpec.describe Xmode2, type: :model, swars_spec: true do
    it "name" do
      assert { Xmode2.fetch("通常").name == "通常" }
      assert { Xmode2.fetch("スプリント").name == "スプリント" }
    end

    it "relation" do
      xmode2 = Xmode2.fetch("スプリント")
      user1 = User.create!(user_key: "user1")
      user2 = User.create!(user_key: "user2")
      battle = Battle.create_with_members!([user1, user2], xmode2: xmode2)
      assert { battle.xmode2 == xmode2 }

      assert { xmode2.battles == [battle] }
      assert { xmode2.memberships == battle.memberships }
    end
  end
end
