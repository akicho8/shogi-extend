# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Profile (actb_profiles as Actb::Profile)
#
# |------------------+------------------+------------+-------------+-----------------------+-------|
# | name             | desc             | type       | opts        | refs                  | index |
# |------------------+------------------+------------+-------------+-----------------------+-------|
# | id               | ID               | integer(8) | NOT NULL PK |                       |       |
# | user_id          | User             | integer(8) |             | => Colosseum::User#id | A! B  |
# | season_id        | Season           | integer(8) |             |                       | A! C  |
# | rating           | Rating           | integer(4) | NOT NULL    |                       | D     |
# | rating_last_diff | Rating last diff | integer(4) | NOT NULL    |                       | E     |
# | rating_max       | Rating max       | integer(4) | NOT NULL    |                       | F     |
# | rensho_count     | Rensho count     | integer(4) | NOT NULL    |                       | G     |
# | renpai_count     | Renpai count     | integer(4) | NOT NULL    |                       | H     |
# | rensho_max       | Rensho max       | integer(4) | NOT NULL    |                       | I     |
# | renpai_max       | Renpai max       | integer(4) | NOT NULL    |                       | J     |
# | create_count     | Create count     | integer(4) | NOT NULL    |                       | K     |
# | generation       | Generation       | integer(4) | NOT NULL    |                       | L     |
# | created_at       | 作成日時         | datetime   | NOT NULL    |                       |       |
# | updated_at       | 更新日時         | datetime   | NOT NULL    |                       |       |
# |------------------+------------------+------------+-------------+-----------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# Colosseum::User.has_one :actb_profile
#--------------------------------------------------------------------------------

module Actb
  class Profile < ApplicationRecord
    belongs_to :user, class_name: "Colosseum::User"
    belongs_to :season

    scope :newest_order, -> { order(generation: :desc) }
    scope :oldest_order, -> { order(generation: :asc)  }

    before_validation do
      self.rating ||= EloRating.rating_default
      self.rating_max ||= EloRating.rating_default
      self.rating_last_diff ||= 0

      if v = changes_to_save[:rating]
        ov, nv = v
        if ov && nv
          self.rating_last_diff = nv - ov
        end
      end

      if rating_max < rating
        self.rating_max = rating
      end

      self.rensho_count ||= 0
      self.renpai_count ||= 0
      self.rensho_max ||= 0
      self.renpai_max ||= 0

      if rensho_max < rensho_count
        self.rensho_max = rensho_count
      end

      if renpai_max < renpai_count
        self.renpai_max = renpai_count
      end

      self.battle_count ||= 0

      self.win_count ||= 0
      self.lose_count ||= 0
      self.win_rate ||= 0

      if changes_to_save[:win_count] || changes_to_save[:lose_count]
        d = win_count + lose_count
        if d.positive?
          self.win_rate = win_count.fdiv(d)
        end
      end
    end

    before_validation do
      self.season ||= Season.newest
      self.generation ||= season.generation
      self.create_count ||= user.actb_profiles.count.next
    end

    with_options presence: true do
      validates :user_id
      validates :season_id
    end

    with_options allow_blank: true do
      validates :user_id, uniqueness: { scope: :season_id }
    end
  end
end
