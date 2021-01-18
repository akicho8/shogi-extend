# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Season (wbook_seasons as Wbook::Season)
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

module Wbook
  RSpec.describe Season, type: :model do
    include WbookSupportMethods

    it "単に新しいレコードを作るだけでユーザーの新シーズンに切り替わる" do
      assert { Season.newest.generation                   == 1 }
      assert { user1.wbook_latest_xrecord.season.generation == 1 }
      assert { Season.create!.generation                  == 2 }
      assert { user1.wbook_latest_xrecord.season.generation == 2 }
    end

    # xit "レーティングを引き継ぐ" do
    #   assert { user1.rating == 1500 }
    #   user1.wbook_main_xrecord.update!(rating: 1501)
    #   assert { user1.rating  == 1501 }
    #   Wbook::Season.create!
    #   assert { user1.wbook_latest_xrecord.rating == 1501 }
    # end

    it "レーティングを引き継がない" do
      assert { user1.rating == 1500 }
      user1.wbook_main_xrecord.update!(rating: 1501)
      assert { user1.rating  == 1501 }
      Wbook::Season.create!
      assert { user1.wbook_latest_xrecord.rating == 1500 }
    end

    it "このシーズンを持っている profiles" do
      assert { Season.newest.xrecords }
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> ...
# >>
# >> Finished in 0.62592 seconds (files took 2.16 seconds to load)
# >> 3 examples, 0 failures
# >>
