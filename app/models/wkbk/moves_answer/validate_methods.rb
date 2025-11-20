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
# | moves_str       | 指し手          | string(255) | NOT NULL    |      |       |
# | moves_human_str | Moves human str | string(255) |             |      |       |
# | position        | 順序            | integer(4)  | NOT NULL    |      | C     |
# | created_at      | 作成日時        | datetime    | NOT NULL    |      |       |
# | updated_at      | 更新日時        | datetime    | NOT NULL    |      |       |
# |-----------------+-----------------+-------------+-------------+------+-------|

module Wkbk
  class MovesAnswer
    concern :ValidateMethods do
      included do
        validate do
          if article
            if article.moves_answer_validate_skip
            else
              if moves_str.present?
                [
                  :validate1_leagal_hands,         # 合法手のみで構成されている
                  :validate2_uniq_with_parent,     # 同じ組み合わせがない
                  :validate3_piece_box_is_empty,   # 「詰将棋」なら先手の駒が空
                  :validate4_all_piece_exists,     # 「詰将棋」なら玉方持駒限定になっていない
                  :validate5_all_piece_not_exists, # 「持駒限定詰将棋」なら持駒が不足している
                  :validate6_mate,                 # 「詰将棋」「持駒限定詰将棋」「実戦詰め筋」なら最後は詰んでいる
                ].each do |e|
                  if errors.present?
                    break
                  end
                  public_send(e)
                end
              end
            end
          end
        end
      end

      # 不正な手がないことを確認
      def validate1_leagal_hands
        begin
          container
        rescue Bioshogi::BioshogiError => error
          errors.add(:base, error.message.lines.first.strip)
        end
      end

      # 同じ組み合わせがないことを確認
      def validate2_uniq_with_parent
        # 配置が同じ問題たちを取得
        s = article.user.wkbk_articles # 自分が作成したすべての問題が対称
        s = s.where(init_sfen: article.read_attribute(:init_sfen))
        if persisted?
          # ただし自分の所属する配置を除く
          s = s.where.not(id: article.id_in_database)
        end
        # その上で手順まで同じのものがあるか？
        article_ids = self.class.where(article: s).where(moves_str: moves_str).group(:article_id).count.keys
        if article_ids.present?
          articles = Article.find(article_ids)
          str = articles.collect { |e| "「#{e.title}」" }.join
          errors.add(:base, "配置と正解手順の組み合わせが既出の問題#{str}と重複しています")
        end
      end

      # 「詰将棋」なら先手の駒が余っていないことを確認する
      def validate3_piece_box_is_empty
        return if !Config.fetch(:black_piece_zero_check_on_function_enable)

        if article.lineage.pure_info.black_piece_zero_check_on
          if container.opponent_player.piece_box.empty?
            # 攻め手の持駒は空なのでOK
          else
            errors.add(:base, "攻め方の持駒が残っています。持駒が残る場合は「実戦詰め筋」とかにしよう")
          end
        end
      end

      # 「詰将棋」ならすべての駒が存在することを確認 (玉方持駒限定になっていないこと)
      def validate4_all_piece_exists
        if article.lineage.pure_info.piece_counts_check_on
          if not_enough_piece_box.values.any?(&:nonzero?)
            errors.add(:base, "駒の数が変です。正確には#{not_enough_piece_box_to_human}です。玉方の持駒を限定している詰将棋は「持駒限定詰将棋」にしといてください")
          end
        end
      end

      # 「持駒限定詰将棋」なら持駒が不足していることを確認する
      def validate5_all_piece_not_exists
        if article.lineage.pure_info.mochigomagentei
          if not_enough_piece_box.values.all?(&:zero?)
            errors.add(:base, "「持駒限定詰将棋」の指定があるのに玉方の持駒が限定されていません。「詰将棋」の間違いではないですか？")
          end
        end
      end

      # 「詰将棋」か「持駒限定詰将棋」か「実戦詰め筋」なら詰んでいることを確認
      def validate6_mate
        return if !Config.fetch(:mate_validate_on_function_enable)

        if article.lineage.pure_info.mate_validate_on
          if article.mate_skip?
            # 「最後は無駄合」なのでチェックしない
          else
            if container.current_player.my_mate?
              # 詰んでいる
            else
              errors.add(:base, "局面が難しすぎます。無駄合いの場合は「最後は無駄合い」に ON にしといてください。詰みチェックしなくなります")
            end
          end
        end
      end

      private

      def parser
        @parser ||= Transform.parse(sfen)
      end

      def container
        @container ||= parser.container
      end

      # 玉を除いて足りない駒たち
      def not_enough_piece_box
        piece_box = container.not_enough_piece_box # 足りない駒が入っている箱
        if (piece_box[:king] || 0) == 1           # 玉の数が1個残っている場合は削除する
          piece_box.add(king: -1)
        end
        piece_box
      end

      # 不足している駒の情報を人間向けの文字列に変換
      def not_enough_piece_box_to_human
        not_enough_piece_box.collect { |key, count|
          if count.nonzero?
            piece = Bioshogi::Piece.fetch(key)
            ary = []
            ary << "#{piece.name}が#{count.abs}つ"
            if count.negative?
              ary << "多い"
            end
            if count.positive?
              ary << "少ない"
            end
            ary.join
          end
        }.compact.join("のと")
      end
    end
  end
end
