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

class CreateHolidays < ActiveRecord::Migration[6.0]
  def change
    create_table :holidays do |t|
      t.string :name, null: false
      t.date :holiday_on, null: false, index: { unique: true }, comment: "祝日"
    end

    Holiday.setup
  end
end
