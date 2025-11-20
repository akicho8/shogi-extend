# -*- coding: utf-8 -*-

# == Schema Information ==
#
# 指し手 (wkbk_moves_answers as Wkbk::MovesAnswer)
#
# |-----------------+-----------------+-------------+-------------+------+-------|
# | name            | desc            | type        | opts        | refs | index |
# |-----------------+-----------------+-------------+-------------+------+-------|
# | id              | ID              | integer(8)  | NOT NULL PK |      |       |
# | article_id      | Article         | integer(8)  | NOT NULL    |      | A     |
# | moves_count     | Moves count     | integer(4)  | NOT NULL    |      | B     |
# | moves_str       | 指し手          | text(65535) |             |      |       |
# | moves_human_str | Moves human str | text(65535) |             |      |       |
# | position        | 順序            | integer(4)  | NOT NULL    |      | C     |
# | created_at      | 作成日時        | datetime    | NOT NULL    |      |       |
# | updated_at      | 更新日時        | datetime    | NOT NULL    |      |       |
# |-----------------+-----------------+-------------+-------------+------+-------|
#
# - Remarks ----------------------------------------------------------------------
# [Warning: Need to add relation] Wkbk::MovesAnswer モデルに belongs_to :article を追加しよう
# --------------------------------------------------------------------------------

require "rails_helper"

RSpec.describe Wkbk::Article, type: :model do
  include WkbkSupportMethods

  MATE_HAND = "G*5b"          # 52金打

  def case1(lineage_key)
    article = user1.wkbk_articles.new
    article.lineage_key = lineage_key
    article.init_sfen = "position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l18p 1" # 52金打ちで詰みの詰将棋
    article.save!
    article
  end

  it "works" do
    moves_answer = case1("詰将棋").moves_answers.create!(moves_str: MATE_HAND) # 頭金で詰み
    assert { moves_answer.article.turn_max == 1 }                          # 最大手数が親の方に埋められている
  end

  describe "特殊なバリデーション" do
    it "validate1_leagal_hands" do
      moves_answer = case1("詰将棋").moves_answers.create(moves_str: "G*5a") # 52金打ちではなく玉の上に金を打った
      moves_answer.errors.full_messages # => ["駒の上に打とうとしています"]
      assert { moves_answer.errors.present? }
    end

    it "validate2_uniq_with_parent" do
      case1("詰将棋").moves_answers.create!(moves_str: MATE_HAND)
      moves_answer = case1("詰将棋").moves_answers.create(moves_str: MATE_HAND)
      moves_answer.errors.full_messages # => ["配置と正解手順の組み合わせが既出の問題(113)と重複しています"]
      assert { moves_answer.errors.present? }
    end

    it "validate3_piece_box_is_empty" do
      article = user1.wkbk_articles.new
      article.lineage_key = "詰将棋"
      article.init_sfen = "position sfen 4k4/9/4G4/9/9/9/9/9/9 b 2G2r2bg4s4n4l18p 1" # 52金打ちで詰みの詰将棋だが金を2枚持っている
      article.save!

      moves_answer = article.moves_answers.create(moves_str: MATE_HAND)
      moves_answer.errors.full_messages # => ["攻め方の持駒が残っています。持駒が残る場合は「実戦詰め筋」とかにしよう"]
      assert { moves_answer.errors.present? }
    end

    it "validate4_all_piece_exists" do
      article = user1.wkbk_articles.new
      article.lineage_key = "詰将棋"
      article.init_sfen = "position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n3l17p 1" # 52金打ちで詰みの詰将棋だが相手の持駒に香と歩が足りてない
      article.save!

      moves_answer = article.moves_answers.create(moves_str: MATE_HAND)
      moves_answer.errors.full_messages # => ["駒の数が変です。正確には香が1つ少ないのと歩が1つ少ないです。玉方の持駒を限定している詰将棋は「持駒限定詰将棋」にしといてください"]
      assert { moves_answer.errors.present? }
    end

    it "validate5_all_piece_not_exists" do
      moves_answer = case1("持駒限定詰将棋").moves_answers.create(moves_str: MATE_HAND)
      moves_answer.errors.full_messages # => ["玉方の持駒が限定されていません。「詰将棋」の間違いではないですか？"]
      assert { moves_answer.errors.present? }
    end

    it "validate6_mate" do
      moves_answer = case1("詰将棋").moves_answers.create(moves_str: "G*5e") # 52金打ちではなく55金打ちとした
      moves_answer.errors.full_messages # => ["局面が難しすぎます。無駄合いの場合は「最後は無駄合い」に ON にしといてください。詰みチェックしなくなります"]
      assert { moves_answer.errors.present? }
    end
  end

  it "turn_maxの自動更新" do
    article = user1.wkbk_articles.create!
    assert { article.turn_max == 0 }
    article.moves_answers.create!(moves_str: MATE_HAND)
    assert { article.reload.turn_max == 1 }
    article.moves_answers.create!(moves_str: "G*5e")
    assert { article.reload.turn_max == 1 } # 最大手数なので1のまま
    article.moves_answers.destroy_all
    assert { article.reload.turn_max == 0 } # 最大手数が0になる
  end

  it "moves" do
    article = user1.wkbk_articles.create!(init_sfen: "position startpos")
    moves_answer = article.moves_answers.create!(moves: %w[7g7f 8c8d])
    assert { moves_answer.moves == ["7g7f", "8c8d"] }
  end
end
