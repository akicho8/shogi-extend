# -*- coding: utf-8 -*-
# == Schema Information ==
#
# User (tsl_users as Tsl::User)
#
# |-------------------+-------------------+-------------+-------------+------+-------|
# | name              | desc              | type        | opts        | refs | index |
# |-------------------+-------------------+-------------+-------------+------+-------|
# | id                | ID                | integer(8)  | NOT NULL PK |      |       |
# | name              | Name              | string(255) | NOT NULL    |      | A!    |
# | first_age         | First age         | integer(4)  |             |      |       |
# | last_age          | Last age          | integer(4)  |             |      |       |
# | memberships_count | Memberships count | integer(4)  | DEFAULT(0)  |      |       |
# | created_at        | 作成日時          | datetime    | NOT NULL    |      |       |
# | updated_at        | 更新日時          | datetime    | NOT NULL    |      |       |
# |-------------------+-------------------+-------------+-------------+------+-------|

require "tsl"

module Tsl
  class User < ApplicationRecord
    has_many :memberships, dependent: :destroy, inverse_of: :user # 対局時の情報(複数)
    has_many :leagues, through: :memberships                      # 対局(複数)

    def name_with_age
      s = name
      if first_age && last_age
        s += "(#{first_age}-#{last_age})"
      end
      s
    end
  end
end
