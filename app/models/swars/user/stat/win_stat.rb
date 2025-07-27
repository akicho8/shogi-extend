# frozen-string-literal: true

module Swars
  module User::Stat
    class WinStat < Base
      THRESHOLD  = 0.5 # 0.5 を越えた場合にメダルを出すと出すぎるので 0.5〜0.6 ぐらいで調整する
      COUNT_GTEQ = 10  # 居飛車・振り飛車判定はN局以上あったときに有効とする

      delegate *[
        :tag_stat,
      ], to: :stat

      ################################################################################

      def the_ture_master_of_ibis?
        ibi_or_huri(:"居飛車") && !ibi_or_huri(:"振り飛車")
      end

      def the_ture_master_of_furi?
        !ibi_or_huri(:"居飛車") && ibi_or_huri(:"振り飛車")
      end

      def the_ture_master_of_all_rounder?
        [:"居飛車", :"振り飛車"].all? { |e| ibi_or_huri(e) }
      end

      def ibi_or_huri(tag)
        if tag_stat.count_by(tag) >= COUNT_GTEQ # これを入れないと1勝0敗で「真の居飛車党」になってしまう
          exist?(tag)
        end
      end
      private :ibi_or_huri

      ################################################################################

      # 「穴熊マン」か？
      def anaguma_medal?
        Bioshogi::Analysis::GroupInfo["穴熊"].values.any? do |e|
          exist?(e.key)
        end
      end

      ################################################################################

      def ratios_hash
        @ratios_hash ||= tag_stat.ratios_hash.each_with_object({}) do |(tag, ratio), m|
          if ratio > THRESHOLD
            m[tag] = ratio
          end
        end
      end

      def to_h
        ratios_hash
      end
      prepend TagMethods

      ################################################################################
    end
  end
end
