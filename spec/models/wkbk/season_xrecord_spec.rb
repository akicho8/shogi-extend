# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Season xrecord (wkbk_season_xrecords as Wkbk::SeasonXrecord)
#
# |---------------------+---------------------+------------+-------------+--------------+-------|
# | name                | desc                | type       | opts        | refs         | index |
# |---------------------+---------------------+------------+-------------+--------------+-------|
# | id                  | ID                  | integer(8) | NOT NULL PK |              |       |
# | judge_id            | Judge               | integer(8) | NOT NULL    |              | B     |
# | final_id            | Final               | integer(8) | NOT NULL    |              | C     |
# | battle_count        | Battle count        | integer(4) | NOT NULL    |              | D     |
# | win_count           | Win count           | integer(4) | NOT NULL    |              | E     |
# | lose_count          | Lose count          | integer(4) | NOT NULL    |              | F     |
# | win_rate            | Win rate            | float(24)  | NOT NULL    |              | G     |
# | rating              | Rating              | float(24)  | NOT NULL    |              | H     |
# | rating_diff         | Rating diff         | float(24)  | NOT NULL    |              | I     |
# | rating_max          | Rating max          | float(24)  | NOT NULL    |              | J     |
# | straight_win_count  | Straight win count  | integer(4) | NOT NULL    |              | K     |
# | straight_lose_count | Straight lose count | integer(4) | NOT NULL    |              | L     |
# | straight_win_max    | Straight win max    | integer(4) | NOT NULL    |              | M     |
# | straight_lose_max   | Straight lose max   | integer(4) | NOT NULL    |              | N     |
# | skill_id            | Skill               | integer(8) | NOT NULL    |              | O     |
# | skill_point         | Skill point         | float(24)  | NOT NULL    |              |       |
# | skill_last_diff     | Skill last diff     | float(24)  | NOT NULL    |              |       |
# | created_at          | 作成日時            | datetime   | NOT NULL    |              |       |
# | updated_at          | 更新日時            | datetime   | NOT NULL    |              |       |
# | disconnect_count    | Disconnect count    | integer(4) | NOT NULL    |              | P     |
# | disconnected_at     | Disconnected at     | datetime   |             |              |       |
# | user_id             | User                | integer(8) | NOT NULL    | => ::User#id | A! Q  |
# | season_id           | Season              | integer(8) | NOT NULL    |              | A! R  |
# | create_count        | Create count        | integer(4) | NOT NULL    |              | S     |
# | generation          | Generation          | integer(4) | NOT NULL    |              | T     |
# |---------------------+---------------------+------------+-------------+--------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

require 'rails_helper'

module Wkbk
  RSpec.describe SeasonXrecord, type: :model do
    include WkbkSupportMethods

    it "切断記録" do
      record = user1.wkbk_latest_xrecord
      record.final_set(Wkbk::Final.fetch(:f_disconnect))
      assert { record.disconnect_count == 1 }
      assert { record.disconnected_at }
      # tp record
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> .
# >> 
# >> Finished in 0.80865 seconds (files took 2.16 seconds to load)
# >> 1 example, 0 failures
# >> 
