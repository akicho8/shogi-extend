# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Moves answer (actb_moves_answers as Actb::MovesAnswer)
#
# |-----------------+-----------------+-------------+-------------+------+-------|
# | name            | desc            | type        | opts        | refs | index |
# |-----------------+-----------------+-------------+-------------+------+-------|
# | id              | ID              | integer(8)  | NOT NULL PK |      |       |
# | question_id     | Question        | integer(8)  | NOT NULL    |      | A     |
# | moves_count     | Moves count     | integer(4)  | NOT NULL    |      | B     |
# | moves_str       | Moves str       | string(255) | NOT NULL    |      |       |
# | end_sfen        | End sfen        | string(255) |             |      |       |
# | created_at      | 作成日時        | datetime    | NOT NULL    |      |       |
# | updated_at      | 更新日時        | datetime    | NOT NULL    |      |       |
# | moves_human_str | Moves human str | string(255) |             |      |       |
# |-----------------+-----------------+-------------+-------------+------+-------|

module Actb
  class MovesAnswer < ApplicationRecord
    belongs_to :question, counter_cache: true, touch: true

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
            Converter.parse(sfen)
          rescue Bioshogi::BioshogiError => error
            errors.add(:base, error.message.lines.first.strip)
          end
        end
      end

      # 同じ組み合わせがないことを確認
      if errors.empty?
        if will_save_change_to_attribute?(:moves_str) && moves_str
          # 配置が同じ問題たちを取得
          s = Question.active_only.where(init_sfen: question.read_attribute(:init_sfen))
          if persisted?
            # ただし自分の所属する配置を除く
            s = s.where.not(id: question.id_in_database)
          end
          # その上で手順まで同じのものがあるか？
          question_ids = self.class.where(question: s).where(moves_str: moves_str).group(:question_id).count
          if question_ids.present?
            errors.add(:base, "配置と正解手順の組み合わせが既出の問題(#{question_ids.keys.join(', ')})と重複しています")
          end
        end
      end

      # 「詰将棋」なら先手の駒が余っていないことを確認する
      if errors.empty?
        if will_save_change_to_attribute?(:moves_str) && moves_str
          if question.lineage.pure_info.black_piece_zero_check_on
            info = Converter.parse(sfen)
            if info.mediator.opponent_player.piece_box.empty?
              # 攻め手の持駒は空なのでOK
            else
              errors.add(:base, "攻め方の持駒が残っています。持駒が残る場合は「実戦詰め筋」とかにしてください")
            end
          end
        end
      end
    end

    after_validation do
      if errors.empty?
        if will_save_change_to_attribute?(:moves_str) && moves_str.present?
          str = Converter.sfen_to_ki2_str(sfen)
          self.moves_human_str = str.truncate(255, omission: "...")
        end
      end
    end

    after_save_commit do
      if saved_change_to_attribute?(:moves_count)
        question.update_column(:turn_max, question.moves_answers.maximum("moves_count"))
      end
    end

    private

    def sfen
      "#{question.init_sfen} moves #{moves_str}"
    end
  end
end
