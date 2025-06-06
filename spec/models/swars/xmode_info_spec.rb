# -*- coding: utf-8 -*-

# == Swars::Schema Swars::Information ==
#
# Swars::Xmode (swars_xmodes as Swars::Xmode)
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

RSpec.describe Swars::XmodeInfo, type: :model, swars_spec: true do
  it "通常は野良のエイリアスではない" do
    assert { !Swars::XmodeInfo.lookup("通常") }
  end

  it "将棋ウォーズ側のキー(sw_side_key)で引ける" do
    assert { Swars::XmodeInfo.fetch("normal").name == "野良" }
    assert { Swars::XmodeInfo.fetch(:closed_event).name == "大会" }
  end
end
