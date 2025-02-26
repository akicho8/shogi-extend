# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Imode (swars_imodes as Swars::Imode)
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
  RSpec.describe ImodeInfo, type: :model, swars_spec: true do
    it "works" do
      assert { ImodeInfo.fetch(:sprint).name == "スプリント" }
      assert { ImodeInfo.fetch("スプリント").name == "スプリント" }
    end
  end
end
