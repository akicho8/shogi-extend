# -*- coding: utf-8 -*-
# == Schema Information ==
#
# League (tsl_leagues as Tsl::League)
#
# |------------+------------+------------+-------------+------+-------|
# | name       | desc       | type       | opts        | refs | index |
# |------------+------------+------------+-------------+------+-------|
# | id         | ID         | integer(8) | NOT NULL PK |      |       |
# | generation | Generation | integer(4) | NOT NULL    |      | A     |
# | created_at | 作成日時   | datetime   | NOT NULL    |      |       |
# | updated_at | 更新日時   | datetime   | NOT NULL    |      |       |
# |------------+------------+------------+-------------+------+-------|

require "rails_helper"

module Tsl
  RSpec.describe League, type: :model do
    before do
      Tsl.setup
    end

    let :record do
      League.first
    end

    it do
      assert { record.valid? }
    end
  end
end
