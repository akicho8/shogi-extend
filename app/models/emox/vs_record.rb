# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Vs record (emox_vs_records as Emox::VsRecord)
#
# |------------+--------------+--------------+-------------+------+-------|
# | name       | desc         | type         | opts        | refs | index |
# |------------+--------------+--------------+-------------+------+-------|
# | id         | ID           | integer(8)   | NOT NULL PK |      |       |
# | battle_id  | Battle       | integer(8)   | NOT NULL    |      | A     |
# | sfen_body  | SFEN形式棋譜 | string(1536) | NOT NULL    |      |       |
# | created_at | 作成日時     | datetime     | NOT NULL    |      |       |
# | updated_at | 更新日時     | datetime     | NOT NULL    |      |       |
# |------------+--------------+--------------+-------------+------+-------|

module Emox
  class VsRecord < ApplicationRecord
    belongs_to :battle, inverse_of: :memberships

    before_validation do
      self.sfen_body = sfen_body.presence || "position startpos"
    end

    with_options presence: true do
      validates :sfen_body
    end
  end
end
