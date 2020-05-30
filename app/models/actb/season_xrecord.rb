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

module Actb
  class SeasonXrecord < ApplicationRecord
    include XrecordShareMod

    belongs_to :season

    before_validation do
      self.season ||= Season.newest
      self.generation ||= season.generation
      self.create_count ||= user.actb_season_xrecords.count.next
    end

    with_options allow_blank: true do
      validates :user_id, uniqueness: { scope: :season_id }
    end
  end
end
