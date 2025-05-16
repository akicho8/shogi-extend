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

class Holiday < ApplicationRecord
  class << self
    def setup(options = {})
      options = {
        :begin => Time.current.years_ago(1),
        :end   => Time.current.years_since(1),
      }.merge(options)

      HolidayJp.between(options[:begin].to_date, options[:end].to_date.days_ago(1)).each do |e|
        find_or_create_by!(name: e.name, holiday_on: e.date)
      end
    end
  end
end
