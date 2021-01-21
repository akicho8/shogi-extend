# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Moves answer (wkbk_moves_answers as Wkbk::MovesAnswer)
#
# |-----------------+-----------------+-------------+-------------+------+-------|
# | name            | desc            | type        | opts        | refs | index |
# |-----------------+-----------------+-------------+-------------+------+-------|
# | id              | ID              | integer(8)  | NOT NULL PK |      |       |
# | question_id     | Question        | integer(8)  | NOT NULL    |      | A     |
# | moves_count     | Moves count     | integer(4)  | NOT NULL    |      | B     |
# | moves_str       | Moves str       | string(255) | NOT NULL    |      |       |
# | end_sfen        | End sfen        | string(255) |             |      |       |
# | moves_human_str | Moves human str | string(255) |             |      |       |
# | created_at      | 作成日時        | datetime    | NOT NULL    |      |       |
# | updated_at      | 更新日時        | datetime    | NOT NULL    |      |       |
# |-----------------+-----------------+-------------+-------------+------+-------|

require 'rails_helper'

module Wkbk
  RSpec.describe Question, type: :model do
    include WkbkSupportMethods

    MATE_HAND = "G*5b"          # 52金打

    def test1(lineage_key)
      question = user1.wkbk_questions.new
      question.lineage_key = lineage_key
      question.init_sfen = "position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l18p 1" # 52金打ちで詰みの詰将棋
      question.save!
      question
    end

    it "works" do
      moves_answer = test1("詰将棋").moves_answers.create!(moves_str: MATE_HAND) # 頭金で詰み
      assert { moves_answer.question.turn_max == 1 }                          # 最大手数が親の方に埋められている
    end

    describe "特殊なバリデーション" do
      it "validate1_leagal_hands" do
        moves_answer = test1("詰将棋").moves_answers.create(moves_str: "G*5a") # 52金打ちではなく玉の上に金を打った
        moves_answer.errors.full_messages # => ["駒の上に打とうとしています"]
        assert { moves_answer.errors.present? }
      end

      it "validate2_uniq_with_parent" do
        test1("詰将棋").moves_answers.create!(moves_str: MATE_HAND)
        moves_answer = test1("詰将棋").moves_answers.create(moves_str: MATE_HAND)
        moves_answer.errors.full_messages # => ["配置と正解手順の組み合わせが既出の問題(113)と重複しています"]
        assert { moves_answer.errors.present? }
      end

      it "validate3_piece_box_is_empty" do
        question = user1.wkbk_questions.new
        question.lineage_key = "詰将棋"
        question.init_sfen = "position sfen 4k4/9/4G4/9/9/9/9/9/9 b 2G2r2bg4s4n4l18p 1" # 52金打ちで詰みの詰将棋だが金を2枚持っている
        question.save!

        moves_answer = question.moves_answers.create(moves_str: MATE_HAND)
        moves_answer.errors.full_messages # => ["攻め方の持駒が残っています。持駒が残る場合は「実戦詰め筋」とかにしてください"]
        assert { moves_answer.errors.present? }
      end

      it "validate4_all_piece_exists" do
        question = user1.wkbk_questions.new
        question.lineage_key = "詰将棋"
        question.init_sfen = "position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n3l17p 1" # 52金打ちで詰みの詰将棋だが相手の持駒に香と歩が足りてない
        question.save!

        moves_answer = question.moves_answers.create(moves_str: MATE_HAND)
        moves_answer.errors.full_messages # => ["駒の数が変です。正確には香が1つ少ないのと歩が1つ少ないです。玉方の持駒を限定している詰将棋は「玉方持駒限定詰将棋」にしといてください"]
        assert { moves_answer.errors.present? }
      end

      it "validate5_all_piece_not_exists" do
        moves_answer = test1("玉方持駒限定詰将棋").moves_answers.create(moves_str: MATE_HAND)
        moves_answer.errors.full_messages # => ["玉方の持駒が限定されていません。「詰将棋」の間違いではないですか？"]
        assert { moves_answer.errors.present? }
      end

      it "validate6_mate" do
        moves_answer = test1("詰将棋").moves_answers.create(moves_str: "G*5e") # 52金打ちではなく55金打ちとした
        moves_answer.errors.full_messages # => ["局面が難しすぎます。無駄合いの場合は「最後は無駄合い」に ON にしといてください。詰みチェックしなくなります"]
        assert { moves_answer.errors.present? }
      end
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> .......
# >> 
# >> Finished in 1.79 seconds (files took 2.3 seconds to load)
# >> 7 examples, 0 failures
# >> 
