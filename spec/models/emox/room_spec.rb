# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Room (emox_rooms as Emox::Room)
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
# | practice      | Practice      | boolean    |                     |      |       |
# | bot_user_id   | Bot user      | integer(8) |                     |      | E     |
# |---------------+---------------+------------+---------------------+------+-------|

require 'rails_helper'

module Emox
  RSpec.describe Room, type: :model do
    include EmoxSupportMethods

    it "works" do
      room = Room.create_with_members!([User.bot, user1])
      battle = room.battle_create_with_members!
      assert { battle.kind_of?(Emox::Battle) }
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> .
# >> 
# >> Finished in 0.86132 seconds (files took 2.23 seconds to load)
# >> 1 example, 0 failures
# >> 
