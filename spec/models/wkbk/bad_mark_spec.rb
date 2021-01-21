# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Bad mark (wkbk_bad_marks as Wkbk::BadMark)
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
  RSpec.describe BadMark, type: :model do
    include WkbkSupportMethods

    it "低評価" do
      assert { user1.wkbk_bad_marks.create!(question: question1) }
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> .
# >> 
# >> Finished in 0.53321 seconds (files took 2.14 seconds to load)
# >> 1 example, 0 failures
# >> 
