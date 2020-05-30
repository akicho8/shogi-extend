# -*- coding: utf-8 -*-
# == Schema Information ==
#
# SeasonXrecord (actb_season_xrecords as Actb::SeasonXrecord)
#
# |------------------+------------------+------------+-------------+-----------------------+-------|
# | name             | desc             | type       | opts        | refs                  | index |
# |------------------+------------------+------------+-------------+-----------------------+-------|
# | id               | ID               | integer(8) | NOT NULL PK |                       |       |
# | user_id          | User             | integer(8) | NOT NULL    | => Colosseum::User#id | A! B  |
# | season_id        | Season           | integer(8) | NOT NULL    |                       | A! C  |
# | judge_id         | Judge            | integer(8) | NOT NULL    |                       | D     |
# | battle_count     | Battle count     | integer(4) | NOT NULL    |                       | E     |
# | win_count        | Win count        | integer(4) | NOT NULL    |                       | F     |
# | lose_count       | Lose count       | integer(4) | NOT NULL    |                       | G     |
# | win_rate         | Win rate         | float(24)  | NOT NULL    |                       | H     |
# | rating           | Rating           | integer(4) | NOT NULL    |                       | I     |
# | rating_last_diff | Rating last diff | integer(4) | NOT NULL    |                       | J     |
# | rating_max       | Rating max       | integer(4) | NOT NULL    |                       | K     |
# | rensho_count     | Rensho count     | integer(4) | NOT NULL    |                       | L     |
# | renpai_count     | Renpai count     | integer(4) | NOT NULL    |                       | M     |
# | rensho_max       | Rensho max       | integer(4) | NOT NULL    |                       | N     |
# | renpai_max       | Renpai max       | integer(4) | NOT NULL    |                       | O     |
# | create_count     | Create count     | integer(4) | NOT NULL    |                       | P     |
# | generation       | Generation       | integer(4) | NOT NULL    |                       | Q     |
# | created_at       | 作成日時         | datetime   | NOT NULL    |                       |       |
# | updated_at       | 更新日時         | datetime   | NOT NULL    |                       |       |
# |------------------+------------------+------------+-------------+-----------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# Colosseum::User.has_one :actb_season_xrecord
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
