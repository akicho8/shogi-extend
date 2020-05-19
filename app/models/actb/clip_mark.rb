# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Clip mark (actb_clip_marks as Actb::ClipMark)
#
# |-------------+----------+------------+-------------+-----------------------+-------|
# | name        | desc     | type       | opts        | refs                  | index |
# |-------------+----------+------------+-------------+-----------------------+-------|
# | id          | ID       | integer(8) | NOT NULL PK |                       |       |
# | user_id     | User     | integer(8) |             | => Colosseum::User#id | A! B  |
# | question_id | Question | integer(8) |             |                       | A! C  |
# | created_at  | 作成日時 | datetime   | NOT NULL    |                       |       |
# | updated_at  | 更新日時 | datetime   | NOT NULL    |                       |       |
# |-------------+----------+------------+-------------+-----------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# Colosseum::User.has_one :actb_profile
#--------------------------------------------------------------------------------

module Actb
  class ClipMark < ApplicationRecord
    concerning :ShareWithHistoryMethods do
      included do
        include VoteMod
      end

      def good_p
        user.good_p(question)
      end

      def bad_p
        user.bad_p(question)
      end

      def clip_p
        user.clip_p(question)
      end
    end
  end
end
