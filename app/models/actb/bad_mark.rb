# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Bad mark (actb_bad_marks as Actb::BadMark)
#
# |-------------+----------+------------+-------------+-----------------------+-------|
# | name        | desc     | type       | opts        | refs                  | index |
# |-------------+----------+------------+-------------+-----------------------+-------|
# | id          | ID       | integer(8) | NOT NULL PK |                       |       |
# | user_id     | User     | integer(8) | NOT NULL    | => Colosseum::User#id | A! B  |
# | question_id | Question | integer(8) | NOT NULL    |                       | A! C  |
# | created_at  | 作成日時 | datetime   | NOT NULL    |                       |       |
# | updated_at  | 更新日時 | datetime   | NOT NULL    |                       |       |
# |-------------+----------+------------+-------------+-----------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# Colosseum::User.has_one :actb_xrecord
#--------------------------------------------------------------------------------

module Actb
  class BadMark < ApplicationRecord
    include VoteMod
  end
end
