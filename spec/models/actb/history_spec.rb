# -*- coding: utf-8 -*-
# == Schema Information ==
#
# History (actb_histories as Actb::History)
#
# |-------------+----------+------------+-------------+--------------+-------|
# | name        | desc     | type       | opts        | refs         | index |
# |-------------+----------+------------+-------------+--------------+-------|
# | id          | ID       | integer(8) | NOT NULL PK |              |       |
# | user_id     | User     | integer(8) | NOT NULL    | => ::User#id | A     |
# | question_id | Question | integer(8) | NOT NULL    |              | B     |
# | room_id     | Room     | integer(8) |             |              | C     |
# | created_at  | 作成日時 | datetime   | NOT NULL    |              |       |
# | updated_at  | 更新日時 | datetime   | NOT NULL    |              |       |
# | ox_mark_id  | Ox mark  | integer(8) | NOT NULL    |              | D     |
# |-------------+----------+------------+-------------+--------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

require "rails_helper"

module Actb
  RSpec.describe History, type: :model do
    include ActbSupportMethods

    it "解答" do
      membership = battle1.memberships.first
      history = user1.actb_histories.create!(question: question1, ox_mark: Actb::OxMark.fetch(:correct))
      assert { history }
      assert { User.bot.actb_lobby_messages.last.body.match?(/user1.*さん.*本日1問.*解きました/) }
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> .
# >> 
# >> Finished in 1.63 seconds (files took 2.23 seconds to load)
# >> 1 example, 0 failures
# >> 
