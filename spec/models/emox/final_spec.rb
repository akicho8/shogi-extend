# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Final (emox_finals as Emox::Final)
#
# |------------+--------------------+-------------+-------------+------+-------|
# | name       | desc               | type        | opts        | refs | index |
# |------------+--------------------+-------------+-------------+------+-------|
# | id         | ID                 | integer(8)  | NOT NULL PK |      |       |
# | key        | ユニークなハッシュ | string(255) | NOT NULL    |      |       |
# | position   | 順序               | integer(4)  | NOT NULL    |      | A     |
# | created_at | 作成日時           | datetime    | NOT NULL    |      |       |
# | updated_at | 更新日時           | datetime    | NOT NULL    |      |       |
# |------------+--------------------+-------------+-------------+------+-------|

require "rails_helper"

module Emox
  RSpec.describe Final, type: :model do
    include EmoxSupportMethods

    it do
      Emox::Final.all.collect(&:key) # => ["f_give_up", "f_disconnect", "f_timeout", "f_success", "f_draw", "f_pending"]
      assert { Final.all.count >= 1 }
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> .
# >> 
# >> Finished in 0.33465 seconds (files took 2.25 seconds to load)
# >> 1 example, 0 failures
# >> 
