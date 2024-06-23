# frozen-string-literal: true
#
# Swars::User["bsplive"].stat.experimental_style_stat.counts_hash    # => {:rarity_key_R=>11, :rarity_key_SSR=>7, :rarity_key_SR=>15, :rarity_key_N=>4}
# Swars::User["bsplive"].stat.experimental_style_stat.ratios_hash    # => {:rarity_key_SSR=>0.1891891891891892, :rarity_key_SR=>0.40540540540540543, :rarity_key_R=>0.2972972972972973, :rarity_key_N=>0.10810810810810811}
# Swars::User["bsplive"].stat.experimental_style_stat.denominator    # => 37
# Swars::User["bsplive"].stat.experimental_style_stat.majority_ratio # => 0.40540540540540543
# Swars::User["bsplive"].stat.experimental_style_stat.minority_ratio # => 0.5945945945945946
# Swars::User["bsplive"].stat.experimental_style_stat.to_chart       # => [{:name=>"王道", :value=>4}, {:name=>"準王道", :value=>11}, {:name=>"準変態", :value=>15}, {:name=>"変態", :value=>7}]
#
module Swars
  module User::Stat
    class ExperimentalStyleStat < StyleStat
      def counts_hash
        @counts_hash ||= yield_self do
          s = ids_scope.joins(:style).group(Style.arel_table[:key])
          s.count.each_with_object({}) do |(style_key, count), m|
            style_info = StyleInfo[style_key]
            m[style_info.rarity_info.key] = count
          end
        end
      end
    end
  end
end
