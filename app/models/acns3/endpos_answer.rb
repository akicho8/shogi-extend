# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Endpos answer (acns3_endpos_answers as Acns3::EndposAnswer)
#
# |-------------+-------------+-------------+-------------+------+-------|
# | name        | desc        | type        | opts        | refs | index |
# |-------------+-------------+-------------+-------------+------+-------|
# | id          | ID          | integer(8)  | NOT NULL PK |      |       |
# | question_id | Question    | integer(8)  |             |      | A     |
# | limit_turn  | Limit turn  | integer(4)  | NOT NULL    |      | B     |
# | sfen_endpos | Sfen endpos | string(255) | NOT NULL    |      |       |
# | created_at  | 作成日時    | datetime    | NOT NULL    |      |       |
# | updated_at  | 更新日時    | datetime    | NOT NULL    |      |       |
# |-------------+-------------+-------------+-------------+------+-------|

module Acns3
  class EndposAnswer < ApplicationRecord
    belongs_to :question, counter_cache: true

    before_validation do
      if changes_to_save[:sfen_endpos] && v = sfen_endpos.presence
        self.limit_turn = v.split.last
      end
    end

    with_options presence: true do
      validates :sfen_endpos
      validates :limit_turn
    end
  end
end
