# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Season xrecord (actb_season_xrecords as Actb::SeasonXrecord)
#
# |------------------+------------------+------------+-------------+-----------------------+-------|
# | name             | desc             | type       | opts        | refs                  | index |
# |------------------+------------------+------------+-------------+-----------------------+-------|
# | id               | ID               | integer(8) | NOT NULL PK |                       |       |
# | user_id          | User             | integer(8) | NOT NULL    | => Colosseum::User#id | A! B  |
# | season_id        | Season           | integer(8) | NOT NULL    |                       | A! C  |
# | judge_id         | Judge            | integer(8) | NOT NULL    |                       | D     |
# | final_id         | Final            | integer(8) | NOT NULL    |                       | E     |
# | battle_count     | Battle count     | integer(4) | NOT NULL    |                       | F     |
# | win_count        | Win count        | integer(4) | NOT NULL    |                       | G     |
# | lose_count       | Lose count       | integer(4) | NOT NULL    |                       | H     |
# | win_rate         | Win rate         | float(24)  | NOT NULL    |                       | I     |
# | rating           | Rating           | integer(4) | NOT NULL    |                       | J     |
# | rating_last_diff | Rating last diff | integer(4) | NOT NULL    |                       | K     |
# | rating_max       | Rating max       | integer(4) | NOT NULL    |                       | L     |
# | rensho_count     | Rensho count     | integer(4) | NOT NULL    |                       | M     |
# | renpai_count     | Renpai count     | integer(4) | NOT NULL    |                       | N     |
# | rensho_max       | Rensho max       | integer(4) | NOT NULL    |                       | O     |
# | renpai_max       | Renpai max       | integer(4) | NOT NULL    |                       | P     |
# | create_count     | Create count     | integer(4) | NOT NULL    |                       | Q     |
# | generation       | Generation       | integer(4) | NOT NULL    |                       | R     |
# | created_at       | 作成日時         | datetime   | NOT NULL    |                       |       |
# | updated_at       | 更新日時         | datetime   | NOT NULL    |                       |       |
# | disconnect_count | Disconnect count | integer(4) | NOT NULL    |                       | S     |
# | disconnected_at  | Disconnected at  | datetime   |             |                       |       |
# |------------------+------------------+------------+-------------+-----------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# Colosseum::User.has_one :actb_master_xrecord
#--------------------------------------------------------------------------------

require 'rails_helper'

module Actb
  RSpec.describe SeasonXrecord, type: :model do
    include ActbSupportMethods

    it "切断記録" do
      user1.actb_current_xrecord.update!(final: Actb::Final.fetch(:f_disconnect))
      assert { user1.actb_current_xrecord.disconnect_count == 1 }
      assert { user1.actb_current_xrecord.disconnected_at }
      # tp user1.actb_current_xrecord
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> .
# >> 
# >> Finished in 0.58492 seconds (files took 2.15 seconds to load)
# >> 1 example, 0 failures
# >> 
