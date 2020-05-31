# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Battle (actb_battles as Actb::Battle)
#
# |--------------+--------------+------------+-------------+------+-------|
# | name         | desc         | type       | opts        | refs | index |
# |--------------+--------------+------------+-------------+------+-------|
# | id           | ID           | integer(8) | NOT NULL PK |      |       |
# | room_id      | Room         | integer(8) | NOT NULL    |      | A     |
# | parent_id    | Parent       | integer(8) |             |      | B     |
# | rule_id      | Rule         | integer(8) | NOT NULL    |      | C     |
# | final_id     | Final        | integer(8) | NOT NULL    |      | D     |
# | begin_at     | Begin at     | datetime   | NOT NULL    |      | E     |
# | end_at       | End at       | datetime   |             |      | F     |
# | rensen_index | Rensen index | integer(4) | NOT NULL    |      | G     |
# | created_at   | 作成日時     | datetime   | NOT NULL    |      |       |
# | updated_at   | 更新日時     | datetime   | NOT NULL    |      |       |
# |--------------+--------------+------------+-------------+------+-------|

require 'rails_helper'

module Actb
  RSpec.describe SeasonXrecord, type: :model do
    include ActbSupportMethods

    it "切断記録" do
      user1.actb_current_xrecord.update!(final: Actb::Final.fetch(:f_disconnect))
      assert { user1.actb_current_xrecord.disconnect_count == 1 }
      assert { user1.actb_current_xrecord.disconnected_at }
      # tp user1.actb_current_xrecord
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> .
# >> 
# >> Finished in 0.58492 seconds (files took 2.15 seconds to load)
# >> 1 example, 0 failures
# >> 
