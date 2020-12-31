# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Question (ts_master_questions as TsMaster::Question)
#
# |----------+------+-------------+-------------+------+-------|
# | name     | desc | type        | opts        | refs | index |
# |----------+------+-------------+-------------+------+-------|
# | id       | ID   | integer(8)  | NOT NULL PK |      |       |
# | sfen     | Sfen | string(255) | NOT NULL    |      |       |
# | mate     | Mate | integer(4)  | NOT NULL    |      | A! B  |
# | position | 順序 | integer(4)  | NOT NULL    |      | A! C  |
# |----------+------+-------------+-------------+------+-------|

require 'rails_helper'

module TsMaster
  RSpec.describe Question, type: :model do
    it "setup" do
      Question.setup(mate: [3, 5], max: 1)
      assert { Question.mate_eq(3).count == 1 }
      assert { Question.mate_eq(5).count == 1 }
    end

    it "sample" do
      Question.setup(mate: 3, max: 1)
      error = Question.sample(mate: 3, max: 2) rescue $!           # => #<RuntimeError: 3手詰問題を2件取得したかったが1件足りない
      assert { error.message.include?("3手詰問題を2件取得したかったが1件足りない") }

      Question.setup(mate: 3, max: 10)
      srand(0)
      assert { Question.sample(mate: 3, max: 5).collect(&:position) == [5, 0, 3, 7, 9] }
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> ..
# >> 
# >> Finished in 0.20667 seconds (files took 2.35 seconds to load)
# >> 2 examples, 0 failures
# >> 
