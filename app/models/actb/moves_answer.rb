# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Moves answer (actb_moves_answers as Actb::MovesAnswer)
#
# |-------------+-------------+-------------+-------------+------+-------|
# | name        | desc        | type        | opts        | refs | index |
# |-------------+-------------+-------------+-------------+------+-------|
# | id          | ID          | integer(8)  | NOT NULL PK |      |       |
# | question_id | Question    | integer(8)  | NOT NULL    |      | A     |
# | moves_count | Moves count | integer(4)  | NOT NULL    |      | B     |
# | moves_str   | Moves str   | string(255) | NOT NULL    |      |       |
# | end_sfen    | End sfen    | string(255) |             |      |       |
# | created_at  | 作成日時    | datetime    | NOT NULL    |      |       |
# | updated_at  | 更新日時    | datetime    | NOT NULL    |      |       |
# |-------------+-------------+-------------+-------------+------+-------|

module Actb
  class MovesAnswer < ApplicationRecord
    belongs_to :question, counter_cache: true

    before_validation do
      if changes_to_save[:moves_str] && v = moves_str.presence
        self.moves_count = v.split.size
      end
    end

    with_options presence: true do
      validates :moves_str, uniqueness: { scope: :question_id, case_sensitive: true } # JS側でチェックしているので普通は発生しない
      validates :moves_count
      # validates :end_sfen
    end

    validate do
      if errors.blank?
        if changes_to_save[:moves_str] && moves_str
          # 親の init_sfen + 自分の moves_str で重複がないことを確認する
          # TODO: self.class.joins(:question).where(Question.arel_table[:init_sfen].eq(init_sfen)) とした方がいいかも
          s = Question.where(init_sfen: question.read_attribute(:init_sfen))
          if persisted?
            s = s.where.not(id: question.id_in_database)
          end
          if self.class.where(question_id: s.ids).find_by(moves_str: moves_str)
            errors.add(:base, "配置と正解手順の組み合わせが既出の問題と重複しています")
          end
        end
      end
    end
  end
end
