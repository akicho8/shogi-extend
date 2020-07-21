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
      if will_save_change_to_attribute?(:moves_str) && v = moves_str.presence
        self.moves_count = v.split.size
      end
    end

    with_options presence: true do
      validates :moves_str, uniqueness: { scope: :question_id, case_sensitive: true } # JS側でチェックしているので普通は発生しない
      validates :moves_count
      # validates :end_sfen
    end

    validate do
      # 不正な手がないことを確認
      if errors.empty?
        if will_save_change_to_attribute?(:moves_str) && moves_str
          begin
            parsed_info
          rescue Bioshogi::BioshogiError => error
            errors.add(:base, error.message.lines.first.strip)
          end
        end
      end

      # 同じ組み合わせがないことを確認
      if errors.empty?
        if will_save_change_to_attribute?(:moves_str) && moves_str
          # 自分の所属する配置を除いて、配置が同じ問題IDsを取得
          s = Question.where(init_sfen: question.read_attribute(:init_sfen))
          if persisted?
            s = s.where.not(id: question.id_in_database)
          end
          # さらに手順まで同じのものがあるか？
          if self.class.where(question_id: s.ids).find_by(moves_str: moves_str)
            errors.add(:base, "配置と正解手順の組み合わせが既出の問題と重複しています")
          end
        end
      end
    end

    after_save_commit do
      if saved_change_to_attribute?(:moves_count)
        question.update!(turn_max: question.moves_answers.maximum("moves_count"))
      end
    end

    private

    def sfen
      "#{question.init_sfen} moves #{moves_str}"
    end

    def parsed_info
      Bioshogi::Parser.parse(sfen)
    end
  end
end
