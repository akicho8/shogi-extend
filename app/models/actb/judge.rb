# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Judge (actb_judges as Actb::Judge)
#
# |------------+--------------------+-------------+-------------+------+-------|
# | name       | desc               | type        | opts        | refs | index |
# |------------+--------------------+-------------+-------------+------+-------|
# | id         | ID                 | integer(8)  | NOT NULL PK |      |       |
# | key        | ユニークなハッシュ | string(255) | NOT NULL    |      |       |
# | position   | 順序               | integer(4)  | NOT NULL    |      | A     |
# | created_at | 作成日時           | datetime    | NOT NULL    |      |       |
# | updated_at | 更新日時           | datetime    | NOT NULL    |      |       |
# |------------+--------------------+-------------+-------------+------+-------|

module Actb
  class Judge < ApplicationRecord
    include MemoryRecordBind

    scope :win_or_lose, -> { where(key: [:win, :lose]) }

    has_many :battle_memberships, dependent: :destroy

    def flip
      self.class.fetch(pure_info.flip.key)
    end

    def win_or_lose?
      ["win", "lose"].include?(key)
    end
  end
end
