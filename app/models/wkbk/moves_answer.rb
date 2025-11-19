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

module Wkbk
  class MovesAnswer < ApplicationRecord
    MOVES_STR_MAX       = 1000  # moves_str カラムの容量 (本当は65535まで行ける)
    MOVES_HUMAN_STR_MAX = 1000  # moves_human_str_max カラムの容量 (本当は65535/3まで行ける)
    SFEN_ONE_LENGTH     = 6     # SFENの1つ分の指し手の文字長で "1a1b+ " が最大なので6文字とする

    MOVES_MAX = MOVES_STR_MAX / SFEN_ONE_LENGTH # SFENの指し手の最大許容数

    include InfoMethods
    include ValidateMethods

    belongs_to :article, counter_cache: true, touch: true

    acts_as_list touch_on_update: false, top_of_list: 0, scope: :article

    before_validation do
      if will_save_change_to_attribute?(:moves_str) && v = moves_str.presence
        self.moves_count = v.split.size
      end
    end

    with_options presence: true do
      validates :moves_str
      validates :moves_count
    end

    with_options allow_blank: true do
      validates :moves_str, length: { maximum: MOVES_STR_MAX, message: "が長すぎて保存できないので最大#{MOVES_MAX}手ぐらいにしといてください" }
      validates :moves_str, uniqueness: { scope: :article_id, case_sensitive: true } # これはJS側でもチェックしているので普通は発生しない
    end

    after_validation do
      if errors.empty?
        if will_save_change_to_attribute?(:moves_str) && moves_str.present?
          str = Transform.to_ki2_from(sfen)
          self.moves_human_str = str.truncate(MOVES_HUMAN_STR_MAX, omission: "...")
        end
      end
    end

    # 最大の手数を求める
    # SQLで調べているためすべてが保存されてから実行する
    after_save_commit do
      if saved_change_to_attribute?(:moves_count)
        if article
          article.update_column(:turn_max, article.moves_answers.maximum("moves_count"))
        end
      end
    end

    after_destroy_commit do
      if article && !article.destroyed?
        article.update_column(:turn_max, article.moves_answers.maximum("moves_count") || 0)
      end
    end

    def sfen
      "#{article.init_sfen} moves #{moves_str}"
    end

    def moves
      moves_str.to_s.split
    end

    def moves=(av)
      self.moves_str = av.join(" ")
    end
  end
end
