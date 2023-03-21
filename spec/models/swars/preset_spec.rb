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

require "rails_helper"

module Swars
  RSpec.describe "手合割", type: :model, swars_spec: true do
    it "works" do
      battle = Battle.create!
      is_asserted_by { battle.preset_info.name == "平手" }
    end

    it "scope" do
      is_asserted_by { Battle.preset_eq("平手") }
      is_asserted_by { Battle.preset_not_eq("平手") }
    end
  end
end
