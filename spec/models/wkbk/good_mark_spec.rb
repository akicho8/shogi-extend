# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Good mark (wkbk_good_marks as Wkbk::GoodMark)
#
# |-------------+----------+------------+-------------+--------------+-------|
# | name        | desc     | type       | opts        | refs         | index |
# |-------------+----------+------------+-------------+--------------+-------|
# | id          | ID       | integer(8) | NOT NULL PK |              |       |
# | user_id     | User     | integer(8) | NOT NULL    | => ::User#id | A! B  |
# | question_id | Question | integer(8) | NOT NULL    |              | A! C  |
# | created_at  | 作成日時 | datetime   | NOT NULL    |              |       |
# | updated_at  | 更新日時 | datetime   | NOT NULL    |              |       |
# |-------------+----------+------------+-------------+--------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

require 'rails_helper'

module Wkbk
  RSpec.describe GoodMark, type: :model do
    include WkbkSupportMethods

    it "高評価" do
      assert { user1.wkbk_good_marks.create!(question: question1) }
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> .
# >> 
# >> Finished in 0.45722 seconds (files took 2.19 seconds to load)
# >> 1 example, 0 failures
# >> 
