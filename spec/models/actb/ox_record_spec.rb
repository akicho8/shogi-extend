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
# | o_rate      | O rate   | float(24)  |             |      | E     |
# | created_at  | 作成日時 | datetime   | NOT NULL    |      |       |
# | updated_at  | 更新日時 | datetime   | NOT NULL    |      |       |
# |-------------+----------+------------+-------------+------+-------|

require "rails_helper"

module Actb
  RSpec.describe OxRecord, type: :model do
    include ActbSupport

    it "ox_add" do
      question1.ox_add(:o_count)
      question1.ox_add(:o_count)
      question1.ox_add(:x_count)
      ox_record = question1.ox_record

      assert { ox_record.o_count  == 2                  }
      assert { ox_record.x_count  == 1                  }
      assert { ox_record.ox_total == 3                  }
      assert { ox_record.o_rate   == 0.6666666666666666 }
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> .
# >> 
# >> Finished in 0.81795 seconds (files took 2.21 seconds to load)
# >> 1 example, 0 failures
# >> 
