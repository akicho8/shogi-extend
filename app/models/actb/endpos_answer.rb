# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Endpos answer (actb_endpos_answers as Actb::EndposAnswer)
#
# |-------------+------------+-------------+-------------+------+-------|
# | name        | desc       | type        | opts        | refs | index |
# |-------------+------------+-------------+-------------+------+-------|
# | id          | ID         | integer(8)  | NOT NULL PK |      |       |
# | question_id | Question   | integer(8)  |             |      | A     |
# | limit_turn  | Limit turn | integer(4)  | NOT NULL    |      | B     |
# | end_sfen    | End sfen   | string(255) | NOT NULL    |      |       |
# | created_at  | 作成日時   | datetime    | NOT NULL    |      |       |
# | updated_at  | 更新日時   | datetime    | NOT NULL    |      |       |
# |-------------+------------+-------------+-------------+------+-------|

module Actb
  class EndposAnswer < ApplicationRecord
    belongs_to :question, counter_cache: true

    before_validation do
      if changes_to_save[:end_sfen] && v = end_sfen.presence
        self.limit_turn = v.split.last
      end
    end

    with_options presence: true do
      validates :end_sfen
      validates :limit_turn
    end
  end
end
