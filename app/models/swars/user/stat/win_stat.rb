# frozen-string-literal: true

module Swars
  module User::Stat
    class WinStat < Base
      THRESHOLD = 0.58 # 0.5 を越えた場合にメダルを出すと出すぎるので 0.5〜0.6 ぐらいで調整する

      delegate *[
        :tag_stat,
      ], to: :stat

      ################################################################################

      def the_ture_master_of_ibis?
        exist?(:"居飛車") && !exist?(:"振り飛車")
      end

      def the_ture_master_of_furi?
        !exist?(:"居飛車") && exist?(:"振り飛車")
      end

      def the_ture_master_of_all_rounder?
        exist?(:"居飛車") && exist?(:"振り飛車")
      end

      ################################################################################

      def ratios_hash
        @ratios_hash ||= tag_stat.ratios_hash.each_with_object({}) do |(tag, ratio), m|
          if ratio > THRESHOLD  # 「勝ち越し」なので >= ではだめ
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
