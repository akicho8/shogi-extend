# ウォーズ専用の棋譜を生成する
#
# Swars::KifuGenerator.generate(time_list: [3, 1, 2, 2, 2], size: 30) # => [["+5958OU", 597], ["-5152OU", 597], ["+5859OU", 596], ["-5251OU", 596], ["+5958OU", 594], ["-5152OU", 594], ["+5859OU", 592], ["-5251OU", 592], ["+5958OU", 590], ["-5152OU", 590], ["+5859OU", 587], ["-5251OU", 587], ["+5958OU", 586], ["-5152OU", 586], ["+5859OU", 584], ["-5251OU", 584], ["+5958OU", 582], ["-5152OU", 582], ["+5859OU", 580], ["-5251OU", 580], ["+5958OU", 577], ["-5152OU", 577], ["+5859OU", 576], ["-5251OU", 576], ["+5958OU", 574], ["-5152OU", 574], ["+5859OU", 572], ["-5251OU", 572], ["+5958OU", 570], ["-5152OU", 570]]
# Swars::KifuGenerator.generate(rule_key: :three_min, size: 2)        # => [["+5958OU", 177], ["-5152OU", 177]]
#
# ~/src/shogi-extend/experiment/swars/kifu_generator.rb
#
module Swars
  class KifuGenerator
    LOOP_HAND_LIST = ["+5958OU", "-5152OU", "+5859OU", "-5251OU"]                       # 王を上下に動かす
    OUTBREAK_LIST  = ["+1716FU", "-1314FU", "+1615FU", "-1415FU", "+1915KY", "-1115KY"] # 1筋で後手が香車を取るところまで

    class << self
      def generate_n(size)
        generate(size: size)
      end

      def fraud_pattern(options = {})
        options = {
          :time_list => [3, 1, 2, 2, 2],
          :size      => 15 * LocationInfo.count, # ちょうど波形3回分
        }.merge(options)
        generate(**options)
      end

      def no_fraud_pattern(options = {})
        fraud_pattern(size: 14 * LocationInfo.count)
      end

      def outbreak_pattern(options = {})
        options = {
          :hand_list => OUTBREAK_LIST,
          :size      => OUTBREAK_LIST.size,
        }.merge(options)
        generate(**options)
      end

      def generate(...)
        new(...).generate
      end

      def default
        fraud_pattern
      end
    end

    def initialize(options = {})
      @options = {
      }.merge(options)
    end

    def generate
      rest = life_time
      size.times.collect.with_index do |i|
        if i.even?
          rest -= time_cycle.next
        end
        [hand_cycle.next, rest]
      end
    end

    def to_h
      {
        :generate   => generate,
        :rule_info  => rule_info,
        :time_list  => time_list,
        :hand_list  => hand_list,
        :size       => size,
        :life_time  => life_time,
      }
    end

    private

    def hand_cycle
      @hand_cycle ||= hand_list.cycle
    end

    def time_cycle
      @time_cycle ||= time_list.cycle
    end

    def rule_info
      RuleInfo.fetch(@options[:rule_key] || :ten_min)
    end

    def time_list
      @options[:time_list] || [0]
    end

    def hand_list
      @options[:hand_list] || LOOP_HAND_LIST
    end

    def size
      @options[:size] || time_list.size * LocationInfo.count
    end

    def life_time
      @options[:life_time] || rule_info.life_time.to_i
    end
  end
end
