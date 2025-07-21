# -*- coding: utf-8 -*-

# == Schema Information ==
#
# Answer log (wkbk_answer_logs as Wkbk::AnswerLog)
#
# |----------------+-------------+------------+-------------+--------------+-------|
# | name           | desc        | type       | opts        | refs         | index |
# |----------------+-------------+------------+-------------+--------------+-------|
# | id             | ID          | integer(8) | NOT NULL PK |              |       |
# | article_id     | Article     | integer(8) | NOT NULL    |              | A     |
# | answer_kind_id | Answer kind | integer(8) | NOT NULL    |              | B     |
# | book_id        | Book        | integer(8) | NOT NULL    |              | C     |
# | user_id        | User        | integer(8) | NOT NULL    | => ::User#id | D     |
# | spent_sec      | Spent sec   | integer(4) | NOT NULL    |              | E     |
# | created_at     | 作成日時    | datetime   | NOT NULL    |              | F     |
# |----------------+-------------+------------+-------------+--------------+-------|
#
# - Remarks ----------------------------------------------------------------------
# User.has_one :profile
# --------------------------------------------------------------------------------

module Wkbk
  class AnswerLog < ApplicationRecord
    # with_options(readonly: true) do
    belongs_to :article
    belongs_to :answer_kind
    belongs_to :book
    belongs_to :user, class_name: "::User"
    # end

    scope :with_today,   -> t = Time.current { where(created_at: t.beginning_of_day...t.beginning_of_day.tomorrow) }
    scope :with_answer_kind, -> key { where(answer_kind: AnswerKind.fetch(key)) }
    scope :with_o,       -> { with_answer_kind(:correct) }
    scope :without_o,    -> { where.not(answer_kind: AnswerKind.fetch(:correct)) }

    # before_validation do
    #   self.answer_kind ||= AnswerKind.fetch(:mistake)
    # end

    before_validation do
      self.spent_sec ||= 0
    end
  end
end
