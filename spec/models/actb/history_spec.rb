# -*- coding: utf-8 -*-
# == Schema Information ==
#
# History (actb_histories as Actb::History)
#
# |---------------+------------+------------+-------------+------------------------------+-------|
# | name          | desc       | type       | opts        | refs                         | index |
# |---------------+------------+------------+-------------+------------------------------+-------|
# | id            | ID         | integer(8) | NOT NULL PK |                              |       |
# | user_id       | User       | integer(8) | NOT NULL    | => ::User#id                 | A     |
# | question_id   | Question   | integer(8) | NOT NULL    |                              | B     |
# | created_at    | 作成日時   | datetime   | NOT NULL    |                              |       |
# | updated_at    | 更新日時   | datetime   | NOT NULL    |                              |       |
# | room_id       | Room       | integer(8) | NOT NULL    |                              | C     |
# | battle_id     | Battle     | integer(8) | NOT NULL    |                              | D     |
# | membership_id | Membership | integer(8) | NOT NULL    | => Actb::BattleMembership#id | E     |
# | ox_mark_id    | Ox mark    | integer(8) | NOT NULL    |                              | F     |
# | rating        | Rating     | float(24)  | NOT NULL    |                              |       |
# |---------------+------------+------------+-------------+------------------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_many :actb_room_messages
# 【警告:リレーション欠如】Actb::BattleMembershipモデルで has_many :actb/histories されていません
#--------------------------------------------------------------------------------

require 'rails_helper'

module Actb
  RSpec.describe History, type: :model do
    include ActbSupportMethods

    it "解答" do
      membership = battle1.memberships.first
      history = user1.actb_histories.create!(question: question1, membership: membership, ox_mark: Actb::OxMark.fetch(:correct))
      assert { history }
      assert { history.rating }
      # tp history
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> .
# >> 
# >> Finished in 0.79877 seconds (files took 2.22 seconds to load)
# >> 1 example, 0 failures
# >> 
