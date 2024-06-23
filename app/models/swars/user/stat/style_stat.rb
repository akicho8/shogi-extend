# frozen-string-literal: true
#
# Swars::User["bsplive"].stat.style_stat.tactic_count_pair_list # => [[<中原流急戦矢倉>, 1], [<矢倉中飛車>, 1], [<右四間飛車>, 3], [<かまいたち戦法>, 11], [<高田流左玉>, 1], [<角交換型>, 1], [<角換わり>, 1], [<手得角交換型>, 1], [<手損角交換型>, 1], [<相掛かり>, 1], [<向かい飛車>, 7], [<相振り飛車>, 11], [<銀雲雀>, 1], [<ショーダンオリジナル>, 4], [<対振り持久戦>, 2], [<カメレオン戦法>, 1], [<力戦>, 12], [<居玉>, 10], [<カニ囲い>, 14], [<カタ囲い>, 1], [<オールド雁木>, 2], [<居飛車金美濃>, 1], [<舟囲い>, 1], [<ミレニアム囲い>, 1]]
# Swars::User["bsplive"].stat.style_stat.counts_hash            # => {:rarity_key_SSR=>8, :rarity_key_SR=>16, :rarity_key_R=>16, :rarity_key_N=>17}
# Swars::User["bsplive"].stat.style_stat.ratios_hash            # => {:rarity_key_SSR=>0.14035087719298245, :rarity_key_SR=>0.2807017543859649, :rarity_key_R=>0.2807017543859649, :rarity_key_N=>0.2982456140350877}
# Swars::User["bsplive"].stat.style_stat.denominator            # => 57
# Swars::User["bsplive"].stat.style_stat.majority_ratio         # => 0.5789473684210527
# Swars::User["bsplive"].stat.style_stat.minority_ratio         # => 0.42105263157894735
#
module Swars
  module User::Stat
    class StyleStat < Base
      delegate *[
        :ids_scope,
        :tag_stat,
      ], to: :stat

      def to_chart
        @to_chart ||= yield_self do
          if denominator.positive?
            RarityInfo.reverse_each.collect do |e|
              { name: e.style_info.name, value: counts_hash[e.key] || 0 }
            end
          end
        end
      end

      # 王道の割合い
      # これが 0.5 以上なら王道
      def majority_ratio
        @majority_ratio ||= yield_self do
          if denominator.positive?
            RarityInfo.find_all { |e| e.segment == :majority }.sum { |e| ratios_hash[e.key] }
          end
        end
      end

      # 変態の割合い
      # これが 0.5 以上なら変態
      def minority_ratio
        @minority_ratio ||= yield_self do
          if denominator.positive?
            RarityInfo.find_all { |e| e.segment == :minority }.sum { |e| ratios_hash[e.key] }
          end
        end
      end

      # Swars::User["bsplive"].stat.style_stat.ratios_hash     # => {:rarity_key_SSR=>0.14035087719298245, :rarity_key_SR=>0.2807017543859649, :rarity_key_R=>0.2807017543859649, :rarity_key_N=>0.2982456140350877}
      def ratios_hash
        @ratios_hash ||= yield_self do
          if denominator.positive?
            RarityInfo.each_with_object({}) do |e, m|
              m[e.key] = (counts_hash[e.key] || 0).fdiv(denominator)
            end
          end
        end
      end

      # Swars::User["bsplive"].stat.style_stat.denominator     # => 57
      def denominator
        @denominator ||= counts_hash.values.sum
      end

      # Swars::User["bsplive"].stat.style_stat.counts_hash     # => {:rarity_key_SSR=>8, :rarity_key_SR=>16, :rarity_key_R=>16, :rarity_key_N=>17}
      def counts_hash
        @counts_hash ||= yield_self do
          hv = RarityInfo.each_with_object({}) { |e, m| m[e.key] = 0 }
          tactic_count_pair_list.each do |tactic, count|
            if distribution_ratio = tactic.distribution_ratio # 無い場合を考慮すること
              rarity_key = distribution_ratio.fetch(:rarity_key)
              hv[rarity_key] += count
            end
          end
          hv
        end
      end

      # tag_stat.counts_hash を利用することでここでは一度もDBにアクセスしていない
      # これによって 50 ms ほど速くなる
      # Swars::User["bsplive"].stat.style_stat.tactic_count_pair_list # => [[<中原流急戦矢倉>, 1], [<矢倉中飛車>, 1], [<右四間飛車>, 3], [<かまいたち戦法>, 11], [<高田流左玉>, 1], [<角交換型>, 1], [<角換わり>, 1], [<手得角交換型>, 1], [<手損角交換型>, 1], [<相掛かり>, 1], [<向かい飛車>, 7], [<相振り飛車>, 11], [<銀雲雀>, 1], [<ショーダンオリジナル>, 4], [<対振り持久戦>, 2], [<カメレオン戦法>, 1], [<力戦>, 12], [<居玉>, 10], [<カニ囲い>, 14], [<カタ囲い>, 1], [<オールド雁木>, 2], [<居飛車金美濃>, 1], [<舟囲い>, 1], [<ミレニアム囲い>, 1]]
      def tactic_count_pair_list
        @tactic_count_pair_list ||= yield_self do
          counts_hash = tag_stat.counts_hash
          [
            Bioshogi::Explain::AttackInfo,
            Bioshogi::Explain::DefenseInfo,
          ].each_with_object([]) do |klass, a|
            klass.each do |e|
              if count = counts_hash[e.key]
                a << [e, count] # Hash にするより2要素の配列にした方が速い
              end
            end
          end
        end
      end
    end
  end
end
