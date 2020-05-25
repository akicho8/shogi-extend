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
# | ox_mark_id | Ans result | integer(8) |             |                       | E     |
# | created_at    | 作成日時   | datetime   | NOT NULL    |                       |       |
# | updated_at    | 更新日時   | datetime   | NOT NULL    |                       |       |
# |---------------+------------+------------+-------------+-----------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# Colosseum::User.has_one :actb_profile
#--------------------------------------------------------------------------------

module Actb
  class History < ApplicationRecord
    include ClipMark::ShareWithHistoryMethods # belongs_to user and question

    belongs_to :ox_mark

    # TODO: この3つはまったく使ってないので削除するか検討
    belongs_to :room
    belongs_to :battle
    belongs_to :membership, class_name: "Actb::BattleMembership"

    before_validation do
      if membership
        self.battle ||= membership.battle
        self.user ||= membership.user
        self.room ||= membership.battle.room
      end
      self.ox_mark ||= OxMark.fetch(:mistake)
    end
  end
end
