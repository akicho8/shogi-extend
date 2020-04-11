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

require 'rails_helper'

module Tsl
  RSpec.describe User, type: :model do
    before do
      Tsl.setup
    end

    let :record do
      User.first
    end

    it do
      assert { record.valid? }
    end
  end
end
