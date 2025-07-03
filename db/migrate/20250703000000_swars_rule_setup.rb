# -*- coding: utf-8 -*-

# == Schema Information ==
#
# Holiday (holidays as Holiday)
#
# |------------+------------+-------------+-------------+------+-------|
# | name       | desc       | type        | opts        | refs | index |
# |------------+------------+-------------+-------------+------+-------|
# | id         | ID         | integer(8)  | NOT NULL PK |      |       |
# | name       | Name       | string(255) | NOT NULL    |      |       |
# | holiday_on | Holiday on | date        | NOT NULL    |      | A!    |
# |------------+------------+-------------+-------------+------+-------|

class SwarsRuleSetup < ActiveRecord::Migration[6.0]
  def up
    Swars::Rule.setup
    tp Swars::Rule
  end
end
