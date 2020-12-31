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

      # TsMaster::Question.group(:mate).count
      # => {3=>998405, 5=>998827, 7=>999071, 9=>999673, 11=>999998}
      #
      # production では3秒かかる
      # SELECT COUNT(*) AS count_all, `ts_master_questions`.`mate` AS ts_master_questions_mate FROM `ts_master_questions` GROUP BY `ts_master_questions`.`mate`
      #
      def group_mate_count
        Rails.cache.fetch("#{name}/#{__method__}", expires_in: 1.year) do
          group(:mate).count
        end
      end
    end

    scope :mate_eq, -> mate { where(:mate => mate) }

    acts_as_list top_of_list: 0, scope: [:mate]
  end
end
