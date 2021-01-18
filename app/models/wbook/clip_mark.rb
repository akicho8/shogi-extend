# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Clip mark (wbook_clip_marks as Wbook::ClipMark)
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
  class ClipMark < ApplicationRecord
    concerning :ShareWithHistoryMethods do
      included do
        include UserQuestionRef
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

    validate :on => :create do
      # if user.wbook_clip_marks.count >= 1
      #   errors.add(:base, "これ以上は保存できません")
      # end
    end
  end
end
