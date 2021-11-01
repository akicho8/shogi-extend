# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Answer kind (wkbk_answer_kinds as Wkbk::AnswerKind)
#
# |------------+----------+-------------+-------------+------+-------|
# | name       | desc     | type        | opts        | refs | index |
# |------------+----------+-------------+-------------+------+-------|
# | id         | ID       | integer(8)  | NOT NULL PK |      |       |
# | key        | キー     | string(255) | NOT NULL    |      | A!    |
# | position   | 順序     | integer(4)  | NOT NULL    |      | B     |
# | created_at | 作成日時 | datetime    | NOT NULL    |      |       |
# | updated_at | 更新日時 | datetime    | NOT NULL    |      |       |
# |------------+----------+-------------+-------------+------+-------|

module Wkbk
  class AnswerKind < ApplicationRecord
    class << self
      def correct_id
        @correct_id ||= fetch(:correct).id
      end
      def mistake_id
        @mistake_id ||= fetch(:mistake).id
      end
      def correct
        @correct ||= fetch(:correct)
      end
      def mistake
        @mistake ||= fetch(:mistake)
      end
      def o
        @o ||= fetch(:correct)
      end
      def x
        @x ||= fetch(:mistake)
      end
    end

    include MemoryRecordBind::Basic

    delegate :mark, to: :pure_info

    has_many :answer_logs, dependent: :destroy
    has_many :articles, through: :answer_logs
    has_many :books, through: :answer_logs
    has_many :users, through: :answer_logs
  end
end
