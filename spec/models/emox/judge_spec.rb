# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Judge (emox_judges as Emox::Judge)
#
# |------------+----------+-------------+-------------+------+-------|
# | name       | desc     | type        | opts        | refs | index |
# |------------+----------+-------------+-------------+------+-------|
# | id         | ID       | integer(8)  | NOT NULL PK |      |       |
# | key        | キー     | string(255) | NOT NULL    |      |       |
# | position   | 順序     | integer(4)  | NOT NULL    |      | A     |
# | created_at | 作成日時 | datetime    | NOT NULL    |      |       |
# | updated_at | 更新日時 | datetime    | NOT NULL    |      |       |
# |------------+----------+-------------+-------------+------+-------|

require "rails_helper"

module Emox
  RSpec.describe Judge, type: :model do
    include EmoxSupportMethods

    it do
      Emox::Judge.all.collect(&:key) # => ["win", "lose", "draw", "pending"]
      assert { Judge.all.count >= 1 }
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> .
# >> 
# >> Finished in 0.3397 seconds (files took 2.24 seconds to load)
# >> 1 example, 0 failures
# >> 
