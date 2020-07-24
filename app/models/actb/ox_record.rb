# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Ox record (actb_ox_records as Actb::OxRecord)
#
# |-------------+----------+------------+-------------+------+-------|
# | name        | desc     | type       | opts        | refs | index |
# |-------------+----------+------------+-------------+------+-------|
# | id          | ID       | integer(8) | NOT NULL PK |      |       |
# | question_id | Question | integer(8) | NOT NULL    |      | A!    |
# | o_count     | O count  | integer(4) | NOT NULL    |      | B     |
# | x_count     | X count  | integer(4) | NOT NULL    |      | C     |
# | ox_total    | Ox total | integer(4) | NOT NULL    |      | D     |
# | o_rate      | O rate   | float(24)  | NOT NULL    |      | E     |
# | created_at  | 作成日時 | datetime   | NOT NULL    |      |       |
# | updated_at  | 更新日時 | datetime   | NOT NULL    |      |       |
# |-------------+----------+------------+-------------+------+-------|

module Actb
  class OxRecord < ApplicationRecord
    belongs_to :question

    before_validation do
      self.o_count  ||= 0
      self.x_count  ||= 0
      self.ox_total ||= 0

      if will_save_change_to_attribute?(:o_count) || will_save_change_to_attribute?(:x_count)
        o_rate_set
      end
    end

    with_options presence: true do
      validates :o_count
      validates :x_count
      validates :ox_total
    end

    with_options allow_blank: true do
      validates :question_id, uniqueness: true
    end

    def o_rate_set
      self.o_rate = nil
      self.ox_total = nil

      if o_count && x_count
        self.ox_total = o_count + x_count
        if ox_total.positive?
          self.o_rate = o_count.fdiv(ox_total)
        end
      end
    end
  end
end
