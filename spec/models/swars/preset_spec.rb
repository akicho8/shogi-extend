# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Preset (presets as Preset)
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

# == Swars::Schema Swars::Information ==
#
# Swars::Preset (presets as Swars::Preset)
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

RSpec.describe "手合割", type: :model, swars_spec: true do
  it "works" do
    battle = Swars::Battle.create!
    assert { battle.preset_info.name == "平手" }
  end

  it "scope" do
    assert { Swars::Battle.preset_eq("平手") }
    assert { Swars::Battle.preset_not_eq("平手") }
  end
end
