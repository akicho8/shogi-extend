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

module TsMaster
  class Question < ApplicationRecord
    class << self
      # rails r 'TsMaster::Question.setup(mate: 3, max: 100)'
      def setup(options = {})
        QuestionImport.new(self, options).all_import
      end

      # rails r 'p TsMaster::Question.sample(mate: 3, max: 10).collect(&:position)'
      def sample(params = {})
        QuestionSample.new(self, params).sample
      end
    end

    scope :mate_eq, -> mate { where(:mate => mate) }

    acts_as_list top_of_list: 0, scope: [:mate]
  end
end
