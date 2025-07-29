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
  before do
    PermanentVariable.destroy_all
  end

  it "初期値" do
    assert { PermanentVariable["A"] == nil }
  end

  it "基本" do
    PermanentVariable["A"] = "x"
    assert { PermanentVariable["A"] == "x" }
  end

  it "ハッシュの場合、キーを文字列で入れても、取り出したときはシンボルになっている" do
    PermanentVariable["A"] = { "x" => 1 }
    assert { PermanentVariable["A"] == { x: 1 } }
  end

  it "配列" do
    PermanentVariable["A"] = ["x"]
    assert { PermanentVariable["A"] == ["x"] }
  end

  it "空文字を設定できる" do
    PermanentVariable["A"] = ""
    assert { PermanentVariable["A"] == "" }
  end

  it "nil を設定できる" do
    PermanentVariable["A"] = "foo"
    PermanentVariable["A"] = nil
    assert { PermanentVariable["A"] == nil }
  end
end
