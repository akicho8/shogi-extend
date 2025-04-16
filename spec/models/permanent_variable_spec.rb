# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Permanent variable (permanent_variables as PermanentVariable)
#
# |------------+----------+-------------+-------------+------+-------|
# | name       | desc     | type        | opts        | refs | index |
# |------------+----------+-------------+-------------+------+-------|
# | id         | ID       | integer(8)  | NOT NULL PK |      |       |
# | key        | キー     | string(255) | NOT NULL    |      | A!    |
# | value      | Value    | json        | NOT NULL    |      |       |
# | created_at | 作成日時 | datetime    | NOT NULL    |      |       |
# | updated_at | 更新日時 | datetime    | NOT NULL    |      |       |
# |------------+----------+-------------+-------------+------+-------|

require "rails_helper"

RSpec.describe PermanentVariable, type: :model, swars_spec: true do
  it "works" do
    PermanentVariable.destroy_all

    assert { PermanentVariable["A"] == nil }

    PermanentVariable["A"] = "x"
    assert { PermanentVariable["A"] == "x" }

    PermanentVariable["A"] = { "x" => 1 }
    assert { PermanentVariable["A"] == { x: 1 } }
  end
end
