# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Profile (actf_profiles as Actf::Profile)
#
# |------------------+------------------+------------+-------------+-----------------------+-------|
# | name             | desc             | type       | opts        | refs                  | index |
# |------------------+------------------+------------+-------------+-----------------------+-------|
# | id               | ID               | integer(8) | NOT NULL PK |                       |       |
# | user_id          | User             | integer(8) |             | => Colosseum::User#id | A     |
# | rating           | Rating           | integer(4) | NOT NULL    |                       | B     |
# | rating_last_diff | Rating last diff | integer(4) | NOT NULL    |                       | C     |
# | rating_max       | Rating max       | integer(4) | NOT NULL    |                       | D     |
# | rensho_count     | Rensho count     | integer(4) | NOT NULL    |                       | E     |
# | renpai_count     | Renpai count     | integer(4) | NOT NULL    |                       | F     |
# | rensho_max       | Rensho max       | integer(4) | NOT NULL    |                       | G     |
# | renpai_max       | Renpai max       | integer(4) | NOT NULL    |                       | H     |
# | created_at       | 作成日時         | datetime   | NOT NULL    |                       |       |
# | updated_at       | 更新日時         | datetime   | NOT NULL    |                       |       |
# |------------------+------------------+------------+-------------+-----------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# Colosseum::User.has_many :actf_memberships
#--------------------------------------------------------------------------------

module Actf
  class Profile < ApplicationRecord
    belongs_to :user, class_name: "Colosseum::User"

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
    end
  end
end
