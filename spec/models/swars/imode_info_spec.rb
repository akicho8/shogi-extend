# -*- coding: utf-8 -*-

# == Swars::Schema Swars::Information ==
#
# Swars::Imode (swars_imodes as Swars::Imode)
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

RSpec.describe Swars::ImodeInfo, type: :model, swars_spec: true do
  it "works" do
    assert { Swars::ImodeInfo.fetch(:sprint).name == "スプリント" }
    assert { Swars::ImodeInfo.fetch("スプリント").name == "スプリント" }
  end
end
