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
# | battle_id       | Battle       | integer(8) |             |                       | B     |
# | membership_id | Membership | integer(8) |             |                       | C     |
# | question_id   | Question   | integer(8) |             |                       | D     |
# | ans_result_id | Ans result | integer(8) |             |                       | E     |
# | created_at    | 作成日時   | datetime   | NOT NULL    |                       |       |
# | updated_at    | 更新日時   | datetime   | NOT NULL    |                       |       |
# |---------------+------------+------------+-------------+-----------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# Colosseum::User.has_one :actb_profile
#--------------------------------------------------------------------------------

module Actb
  class History < ApplicationRecord
    include ClipMark::ShareWithHistoryMethods

    belongs_to :ans_result

    # battle と membership ない方がいいか検討
    # battle と membership はビューでまったく使ってない
    belongs_to :battle
    belongs_to :membership

    before_validation do
      if membership
        self.battle ||= membership.battle
        self.user ||= membership.user
      end
      self.ans_result ||= AnsResult.fetch(:mistake)
    end
  end
end
