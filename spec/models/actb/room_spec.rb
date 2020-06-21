# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Room (actb_rooms as Actb::Room)
#
# |---------------+---------------+------------+---------------------+------+-------|
# | name          | desc          | type       | opts                | refs | index |
# |---------------+---------------+------------+---------------------+------+-------|
# | id            | ID            | integer(8) | NOT NULL PK         |      |       |
# | begin_at      | Begin at      | datetime   | NOT NULL            |      | A     |
# | end_at        | End at        | datetime   |                     |      | B     |
# | rule_id       | Rule          | integer(8) | NOT NULL            |      | C     |
# | created_at    | 作成日時      | datetime   | NOT NULL            |      |       |
# | updated_at    | 更新日時      | datetime   | NOT NULL            |      |       |
# | battles_count | Battles count | integer(4) | DEFAULT(0) NOT NULL |      | D     |
# |---------------+---------------+------------+---------------------+------+-------|

require 'rails_helper'

module Actb
  RSpec.describe Room, type: :model do
    include ActbSupportMethods

    it "バトル生成" do
      assert { room1.battle_create_with_members!.kind_of?(Actb::Battle) }
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> .
# >> 
# >> Finished in 0.69169 seconds (files took 2.2 seconds to load)
# >> 1 example, 0 failures
# >> 
