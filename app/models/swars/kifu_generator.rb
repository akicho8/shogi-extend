# ウォーズ専用の棋譜を生成する
#
# Swars::KifuGenerator.generate(time_list: [3, 1, 2, 2, 2], size: 30) # => [["+5958OU", 597], ["-5152OU", 597], ["+5859OU", 596], ["-5251OU", 596], ["+5958OU", 594], ["-5152OU", 594], ["+5859OU", 592], ["-5251OU", 592], ["+5958OU", 590], ["-5152OU", 590], ["+5859OU", 587], ["-5251OU", 587], ["+5958OU", 586], ["-5152OU", 586], ["+5859OU", 584], ["-5251OU", 584], ["+5958OU", 582], ["-5152OU", 582], ["+5859OU", 580], ["-5251OU", 580], ["+5958OU", 577], ["-5152OU", 577], ["+5859OU", 576], ["-5251OU", 576], ["+5958OU", 574], ["-5152OU", 574], ["+5859OU", 572], ["-5251OU", 572], ["+5958OU", 570], ["-5152OU", 570]]
# Swars::KifuGenerator.generate(rule_key: :three_min, size: 2)        # => [["+5958OU", 177], ["-5152OU", 177]]
#
# ~/src/shogi-extend/experiment/swars/kifu_generator.rb
#
module Swars
  class KifuGenerator
    DEFAULT_TIME_LIST = [3, 1, 2, 2, 2]
    DEFAULT_SIZE      = 50
    DEFAULT_HAND_LIST = ["+5958OU", "-5152OU", "+5859OU", "-5251OU"]

    class << self
      def generate(...)
        new(...).generate
      end

      def default
        generate_ai
      end

      def generate_ai(options = {})
        options = {
          :size => 15 * LocationInfo.count, # ちょうど波形3回分
        }.merge(options)
        generate(**options)
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
      @options[:time_list] || DEFAULT_TIME_LIST
    end

    def hand_list
      @options[:hand_list] || DEFAULT_HAND_LIST
    end

    def size
      @options[:size] || DEFAULT_SIZE
    end

    def life_time
      @options[:life_time] || rule_info.life_time.to_i
    end
  end
end
