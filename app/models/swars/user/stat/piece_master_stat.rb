# frozen-string-literal: true

module Swars
  module User::Stat
    class PieceMasterStat < Base
      THRESHOLD = 1.2           # 1.0 では表示されるバッジが多すぎてありがたみがないので突き出ている場合だけバッジにする

      class << self
        def report(options = {})
          options = {
            :sample_max => 500,
            :user_keys  => User::Vip.auto_crawl_user_keys,
          }.merge(options)

          options[:user_keys].collect { |user_key|
            if user = User[user_key]
              stat = user.stat(options)
              piece_master_stat = stat.piece_master_stat
              {
                :user_key => user.key,
                **piece_master_stat.to_report_h,
              }
            end
          }.compact
        end
      end

      delegate *[
        :piece_stat,
        :ids_count,
      ], to: :stat

      def to_report_h
        Bioshogi::Piece.each_with_object({}) do |e, m|
          # m[e.name] = average_above?(e.name.to_sym) ? "○" : ""
          v = above_level(e.name.to_sym)
          if v >= THRESHOLD
            v = v.round(2)
          else
            v = nil
          end
          m[e.name] = v
        end
      end

      def badge?(piece_name)
        if ids_count >= Config.master_count_gteq
          if stat.win_ratio > 0.5
            above_level(piece_name) >= THRESHOLD
          end
        end
      end

      # 1.0 を越えていれば piece_name は平均よりも活用されている
      def above_level(piece_name)
        piece_name = piece_name
        ratio = piece_stat.ratios_hash.fetch(piece_name)
        avg = FreqPieceInfo[piece_name].ratio

        # 成った駒が活用されている場合「成っていない駒の使い方が上手だったから」ということにするため加算する
        if promoted_name = Bioshogi::Piece[piece_name.to_s].promoted_name
          promoted_name = promoted_name.to_sym
          ratio += piece_stat.ratios_hash.fetch(promoted_name)
          avg += FreqPieceInfo[promoted_name].ratio
        end

        ratio.fdiv(avg)         # 利用割合 / 平均割合
      end

      # 未使用
      # 「平均越え」だと出すぎてしまう
      def average_above?(piece_name)
        above_level(piece_name) > 1.0
      end
    end
  end
end
