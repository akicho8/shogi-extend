# -*- coding: utf-8 -*-
# == Schema Information ==
#
# History (actb_histories as Actb::History)
#
# |---------------+------------+------------+-------------+-----------------------+-------|
# | name          | desc       | type       | opts        | refs                  | index |
# |---------------+------------+------------+-------------+-----------------------+-------|
# | id            | ID         | integer(8) | NOT NULL PK |                       |       |
# | user_id       | User       | integer(8) |             | => Colosseum::User#id | A     |
# | room_id       | Room       | integer(8) |             |                       | B     |
# | membership_id | Membership | integer(8) |             |                       | C     |
# | question_id   | Question   | integer(8) |             |                       | D     |
# | ans_result_id | Ans result | integer(8) |             |                       | E     |
# | created_at    | 作成日時   | datetime   | NOT NULL    |                       |       |
# | updated_at    | 更新日時   | datetime   | NOT NULL    |                       |       |
# |---------------+------------+------------+-------------+-----------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# Colosseum::User.has_many :actb_clip_marks
#--------------------------------------------------------------------------------

module Actb
  class History < ApplicationRecord
    include ClipMark::ShareWithHistoryMethods

    belongs_to :ans_result

    # room と membership ない方がいいか検討
    # room と membership はビューでまったく使ってない
    belongs_to :room
    belongs_to :membership

    before_validation do
      if membership
        self.room ||= membership.room
        self.user ||= membership.user
      end
      self.ans_result ||= AnsResult.fetch(:mistake)
    end
  end
end
