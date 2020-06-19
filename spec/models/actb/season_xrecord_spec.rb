# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Season xrecord (actb_season_xrecords as Actb::SeasonXrecord)
#
# |------------------+------------------+---------------+-------------+--------------+-------|
# | name             | desc             | type          | opts        | refs         | index |
# |------------------+------------------+---------------+-------------+--------------+-------|
# | id               | ID               | integer(8)    | NOT NULL PK |              |       |
# | judge_id         | Judge            | integer(8)    | NOT NULL    |              | B     |
# | final_id         | Final            | integer(8)    | NOT NULL    |              | C     |
# | battle_count     | Battle count     | integer(4)    | NOT NULL    |              | D     |
# | win_count        | Win count        | integer(4)    | NOT NULL    |              | E     |
# | lose_count       | Lose count       | integer(4)    | NOT NULL    |              | F     |
# | win_rate         | Win rate         | float(24)     | NOT NULL    |              | G     |
# | rating           | Rating           | decimal(8, 4) | NOT NULL    |              | H     |
# | rating_diff      | Rating diff      | decimal(8, 4) | NOT NULL    |              | I     |
# | rating_max       | Rating max       | decimal(8, 4) | NOT NULL    |              | J     |
# | rensho_count     | Rensho count     | integer(4)    | NOT NULL    |              | K     |
# | renpai_count     | Renpai count     | integer(4)    | NOT NULL    |              | L     |
# | rensho_max       | Rensho max       | integer(4)    | NOT NULL    |              | M     |
# | renpai_max       | Renpai max       | integer(4)    | NOT NULL    |              | N     |
# | udemae_id        | Udemae           | integer(8)    | NOT NULL    |              | O     |
# | udemae_point     | Udemae point     | decimal(7, 4) | NOT NULL    |              |       |
# | udemae_last_diff | Udemae last diff | decimal(7, 4) | NOT NULL    |              |       |
# | created_at       | 作成日時         | datetime      | NOT NULL    |              |       |
# | updated_at       | 更新日時         | datetime      | NOT NULL    |              |       |
# | disconnect_count | Disconnect count | integer(4)    | NOT NULL    |              | P     |
# | disconnected_at  | Disconnected at  | datetime      |             |              |       |
# | user_id          | User             | integer(8)    | NOT NULL    | => ::User#id | A! Q  |
# | season_id        | Season           | integer(8)    | NOT NULL    |              | A! R  |
# | create_count     | Create count     | integer(4)    | NOT NULL    |              | S     |
# | generation       | Generation       | integer(4)    | NOT NULL    |              | T     |
# |------------------+------------------+---------------+-------------+--------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_many :actb_room_messages
#--------------------------------------------------------------------------------

require 'rails_helper'

module Actb
  RSpec.describe SeasonXrecord, type: :model do
    include ActbSupportMethods

    it "切断記録" do
      record = user1.actb_latest_xrecord
      record.final_set(Actb::Final.fetch(:f_disconnect))
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
