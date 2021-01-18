# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Good mark (wbook_good_marks as Wbook::GoodMark)
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

module Wbook
  class GoodMark < ApplicationRecord
    include UserQuestionRef
  end
end
