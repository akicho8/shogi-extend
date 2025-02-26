# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Xmode2 (swars_xmode2s as Swars::Xmode2)
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
  RSpec.describe Xmode2Info, type: :model, swars_spec: true do
    it "works" do
      assert { Xmode2Info.fetch(:sprint).name == "スプリント" }
      assert { Xmode2Info.fetch("スプリント").name == "スプリント" }
    end
  end
end
