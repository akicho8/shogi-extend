# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Rule (actb_rules as Actb::Rule)
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

require 'rails_helper'

module Actb
  RSpec.describe Rule, type: :model do
    include ActbSupportMethods

    it do
      Actb::Rule.all.collect(&:key) # => ["sy_marathon", "sy_singleton", "sy_hybrid"]
      assert { Rule.all.count >= 1 }
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> .
# >>
# >> Finished in 0.32605 seconds (files took 2.15 seconds to load)
# >> 1 example, 0 failures
# >>
