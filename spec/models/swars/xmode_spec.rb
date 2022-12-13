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
  RSpec.describe Xmode, type: :model, swars_spec: true do
    it "name" do
      assert { Xmode.fetch("野良").name == "野良" }
      assert { Xmode.fetch("友達").name == "友達" }
    end

    it "relation" do
      xmode = Xmode.fetch("友達")
      user1 = User.create!(user_key: "user1")
      user2 = User.create!(user_key: "user2")
      battle = Battle.create_with_members!([user1, user2], xmode: xmode)
      assert { battle.xmode == xmode }

      assert { xmode.battles == [battle] }
      assert { xmode.memberships == battle.memberships }
    end
  end
end
