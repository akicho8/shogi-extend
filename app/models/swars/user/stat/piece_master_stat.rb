# frozen-string-literal: true

module Swars
  module User::Stat
    class PieceMasterStat < Base
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
      ], to: :stat

      def to_report_h
        Bioshogi::Piece.each_with_object({}) do |e, m|
          m[e.name] = average_above?(e.name.to_sym) ? "○" : ""
        end
      end

      def win_average_above?(piece_name)
        if stat.win_ratio > 0.5
          average_above?(piece_name)
        end
      end

      def average_above?(piece_name)
        a = piece_name
        ratio_a = piece_stat.ratios_hash.fetch(a)
        ratio_b = FreqPieceInfo[a].ratio

        if b = Bioshogi::Piece[piece_name.to_s].promoted_name
          b = b.to_sym
          ratio_a += piece_stat.ratios_hash.fetch(b)
          ratio_b += FreqPieceInfo[b].ratio
        end

        ratio_a > ratio_b
      end
    end
  end
end
