# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Season (actb_seasons as Actb::Season)
#
# |------------+------------+-------------+-------------+------+-------|
# | name       | desc       | type        | opts        | refs | index |
# |------------+------------+-------------+-------------+------+-------|
# | id         | ID         | integer(8)  | NOT NULL PK |      |       |
# | name       | Name       | string(255) | NOT NULL    |      |       |
# | generation | Generation | integer(4)  | NOT NULL    |      | A     |
# | begin_at   | Begin at   | datetime    | NOT NULL    |      | B     |
# | end_at     | End at     | datetime    | NOT NULL    |      | C     |
# | created_at | 作成日時   | datetime    | NOT NULL    |      |       |
# | updated_at | 更新日時   | datetime    | NOT NULL    |      |       |
# |------------+------------+-------------+-------------+------+-------|

require 'rails_helper'

module Actb
  RSpec.describe Season, type: :model do
    let_it_be :user do
      Colosseum::User.create!
    end

    it "単に新しいレコードを作るだけでユーザーの新シーズンに切り替わる" do
      assert { Season.newest.generation                   == 1 }
      assert { user.actb_current_xrecord.season.generation == 1 }
      assert { Season.create!.generation                  == 2 }
      assert { user.actb_current_xrecord.season.generation == 2 }
    end

    it "このシーズンを持っている profiles" do
      assert { Season.newest.profiles }
    end
  end
end
