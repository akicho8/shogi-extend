# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Battle (emox_battles as Emox::Battle)
#
# |------------+------------+------------+-------------+------+-------|
# | name       | desc       | type       | opts        | refs | index |
# |------------+------------+------------+-------------+------+-------|
# | id         | ID         | integer(8) | NOT NULL PK |      |       |
# | room_id    | Room       | integer(8) | NOT NULL    |      | A     |
# | parent_id  | Parent     | integer(8) |             |      | B     |
# | rule_id    | Rule       | integer(8) | NOT NULL    |      | C     |
# | final_id   | Final      | integer(8) | NOT NULL    |      | D     |
# | begin_at   | Begin at   | datetime   | NOT NULL    |      | E     |
# | end_at     | End at     | datetime   |             |      | F     |
# | battle_pos | Battle pos | integer(4) | NOT NULL    |      | G     |
# | practice   | Practice   | boolean    |             |      |       |
# | created_at | 作成日時   | datetime   | NOT NULL    |      |       |
# | updated_at | 更新日時   | datetime   | NOT NULL    |      |       |
# |------------+------------+------------+-------------+------+-------|

require "rails_helper"

module Emox
  RSpec.describe Battle, type: :model do
    include EmoxSupportMethods

    it "final_keyをセットしたタイミングで終了時刻も設定" do
      battle1.update!(final: Emox::Final.fetch(:f_success))
      assert { battle1.end_at }
    end

    it "続きのバトル作成" do
      new_battle = battle1.battle_chain_create
      assert { new_battle.kind_of?(Emox::Battle) }
      assert { new_battle.battle_pos == 1 }
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> ..
# >> 
# >> Finished in 1.02 seconds (files took 2.26 seconds to load)
# >> 2 examples, 0 failures
# >> 
