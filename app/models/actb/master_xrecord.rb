# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Master xrecord (actb_master_xrecords as Actb::MasterXrecord)
#
# |------------------+------------------+---------------+-------------+--------------+-------|
# | name             | desc             | type          | opts        | refs         | index |
# |------------------+------------------+---------------+-------------+--------------+-------|
# | id               | ID               | integer(8)    | NOT NULL PK |              |       |
# | user_id          | User             | integer(8)    | NOT NULL    | => ::User#id | A!    |
# | judge_id         | Judge            | integer(8)    | NOT NULL    |              | B     |
# | final_id         | Final            | integer(8)    | NOT NULL    |              | C     |
# | battle_count     | Battle count     | integer(4)    | NOT NULL    |              | D     |
# | win_count        | Win count        | integer(4)    | NOT NULL    |              | E     |
# | lose_count       | Lose count       | integer(4)    | NOT NULL    |              | F     |
# | win_rate         | Win rate         | float(24)     | NOT NULL    |              | G     |
# | rating           | Rating           | decimal(8, 4) | NOT NULL    |              | H     |
# | rating_last_diff | Rating last diff | decimal(8, 4) | NOT NULL    |              | I     |
# | rating_max       | Rating max       | decimal(8, 4) | NOT NULL    |              | J     |
# | rensho_count     | Rensho count     | integer(4)    | NOT NULL    |              | K     |
# | renpai_count     | Renpai count     | integer(4)    | NOT NULL    |              | L     |
# | rensho_max       | Rensho max       | integer(4)    | NOT NULL    |              | M     |
# | renpai_max       | Renpai max       | integer(4)    | NOT NULL    |              | N     |
# | udemae_id        | Udemae           | integer(8)    | NOT NULL    |              | O     |
# | udemae_point     | Udemae point     | decimal(8, 4) | NOT NULL    |              |       |
# | created_at       | 作成日時         | datetime      | NOT NULL    |              |       |
# | updated_at       | 更新日時         | datetime      | NOT NULL    |              |       |
# | disconnect_count | Disconnect count | integer(4)    | NOT NULL    |              | P     |
# | disconnected_at  | Disconnected at  | datetime      |             |              |       |
# |------------------+------------------+---------------+-------------+--------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_many :actb_room_messages
#--------------------------------------------------------------------------------

module Actb
  class MasterXrecord < ApplicationRecord
    include XrecordShareMod

    def rating_default
      EloRating.rating_default
    end
  end
end
