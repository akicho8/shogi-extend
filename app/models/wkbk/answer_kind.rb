# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Ox mark (wkbk_answer_kinds as Wkbk::AnswerKind)
#
# |------------+--------------------+-------------+-------------+------+-------|
# | name       | desc               | type        | opts        | refs | index |
# |------------+--------------------+-------------+-------------+------+-------|
# | id         | ID                 | integer(8)  | NOT NULL PK |      |       |
# | key        | ユニークなハッシュ | string(255) | NOT NULL    |      | A     |
# | position   | 順序               | integer(4)  | NOT NULL    |      | B     |
# | created_at | 作成日時           | datetime    | NOT NULL    |      |       |
# | updated_at | 更新日時           | datetime    | NOT NULL    |      |       |
# |------------+--------------------+-------------+-------------+------+-------|

module Wkbk
  class AnswerKind < ApplicationRecord
    include MemoryRecordBind

    has_many :answer_logs, dependent: :destroy
    has_many :articles, through: :answer_logs
    has_many :books, through: :answer_logs
    has_many :users, through: :answer_logs
  end
end
