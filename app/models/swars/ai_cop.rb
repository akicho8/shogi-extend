# 棋神判定

# 誤判定
# https://www.shogi-extend.com/swars/search?query=bsplive%20%E5%8B%9D%E6%95%97%3A%E5%8B%9D%E3%81%A1%20%E4%B8%AD%E7%9B%A4%E4%BB%A5%E9%99%8D%E3%81%AE%E6%9C%80%E5%A4%A7%E9%80%A3%E7%B6%9A%E5%8D%B3%E6%8C%87%E3%81%97%E5%9B%9E%E6%95%B0%3A%3E%3D10
# https://www.shogi-extend.com/swars/battles/bsplive-yuichen-20240414_184108/?viewpoint=black
# https://www.shogi-extend.com/swars/battles/syutauneri2-bsplive-20240414_173429/?viewpoint=white
# https://www.shogi-extend.com/swars/battles/bsplive-Super212-20240407_142107/?viewpoint=black
# https://www.shogi-extend.com/swars/battles/bsplive-syutyurumuhuto-20240320_223640/?viewpoint=black
# https://www.shogi-extend.com/swars/battles/ponpokoponji-bsplive-20240317_181606/?viewpoint=white
# https://www.shogi-extend.com/swars/battles/bsplive-rocchithebokku-20240317_174432/?viewpoint=black

# 単発
# https://www.shogi-extend.com/swars/battles/bsplive-Marina777-20240221_102647/?viewpoint=black
# https://www.shogi-extend.com/swars/battles/bsplive-si_kun_YouTuber-20231029_201533/?viewpoint=black

# 連続
# https://www.shogi-extend.com/swars/search?query=Marina777

# 参考
# https://www.shogi-extend.com/swars/search?query=bsplive%20%E5%8B%9D%E6%95%97%3A%E8%B2%A0%E3%81%91%20%E7%9B%B8%E6%89%8B%E3%81%AE%E6%A3%8B%E5%8A%9B%3A%E4%B9%9D%E6%AE%B5%20%E5%AF%BE%E5%B1%80%E3%83%A2%E3%83%BC%E3%83%89%3A%E9%87%8E%E8%89%AF

module Swars
  class AiCop
    class << self
      def analize(...)
        obj = new(...)
        obj.analize
        obj
      end

      def test(...)
        analize(...).to_h
      end

      def used?(...)
        analize(...).used?
      end

      # def ai_drop_total(...)
      #   analize(...).ai_drop_total
      # end

      def membership_arrest(m)
        m.judge_key == "win" && m.battle.turn_max >= 50 && (
          (m.ai_drop_total || 0) >= AiCop.ai_drop_total_gteq ||
          (m.ai_wave_count || 0) >= AiCop.ai_wave_count_gteq ||
          (m.ai_two_freq || 0) >= AiCop.ai_two_freq_gteq
        )
      end
    end

    cattr_accessor(:ai_drop_total_gteq) { 15 } # N回以上続けば棋神確定
    cattr_accessor(:ai_wave_count_gteq) { 3 }  # N回以上続けば棋神確定
    cattr_accessor(:ai_two_freq_gteq) { 0.6 }  # 以上 2 があると棋神確定

    FIRST_TRIGGER_GTEQ   = 3 # n 秒以上を指した次に
    ONE_SECOND           = 1 # n 秒で指して続いて
    TWO_SECOND           = 2 # n 秒で
    TWO_CONSECUTIVE_GTEQ = 3 # n 連続以上指したとき棋神チケット1回消費
    TWO_BEFORE_VALUE     = 2 # 連続する TWO_SECOND に入る前の個数

    # 固定
    HANDS_PER_TICKET     = 5 # 1つのチケットで 5 手指す

    attr_reader :list

    # 棋神を使って指した総手数 (重要)
    #
    #  31222       → 5
    #  31222 2     → 6
    #  31222 22222 → 10
    #
    # つまりこれが 10 以上であればチケット2回消費。
    attr_reader :ai_drop_total

    # 棋神チケットを使い始めた回数 (重要)
    # 最初の山の数でしかないため、チケット消費量とは異なる
    #
    #  3122        → 0
    #  31222       → 1
    #  31222 22222 → 1
    #  31222 31222 → 2
    #
    # これが 1 以上で棋神確定。
    attr_reader :ai_wave_count

    attr_reader :ai_two_freq

    def initialize(list)
      @list = list
      @ai_drop_total = nil
      @ai_wave_count = nil
      @ai_two_freq   = nil
    end

    def analize
      mode = :idol
      two_count = 0
      drop_count = 0

      # before_value = nil
      @ai_two_count = 0

      @list.each do |v|
        # if (before_value == 1 || before_value == 2) && v == 2
        if v == 2
          @ai_two_count += 1
        end
        if v >= FIRST_TRIGGER_GTEQ
          mode = :maybe
        else
          case mode
          when :maybe
            if v == ONE_SECOND
              mode = :consecutive_two
              two_count = 0
            else
              mode = :idol
            end
          when :consecutive_two
            if v == TWO_SECOND
              two_count += 1
              if two_count == TWO_CONSECUTIVE_GTEQ
                @ai_wave_count ||= 0
                @ai_wave_count += 1
                @ai_drop_total ||= 0
                @ai_drop_total += TWO_BEFORE_VALUE + two_count
              end
              if two_count > TWO_CONSECUTIVE_GTEQ
                @ai_drop_total += 1
              end
            else
              mode = :idol
            end
          end
        end
        # before_value = v
      end
    end

    # 棋神チケット使用回数
    #
    # 4手指し → 1
    # 5手指し → 1
    # 6手指し → 2
    #
    def ai_ticket_count
      if @ai_drop_total
        @ai_drop_total.ceildiv(HANDS_PER_TICKET)
      end
    end

    # 棋神を使ったか？
    def used?
      if @ai_wave_count
        @ai_wave_count >= 1
      end
    end

    # 2頻出度
    def ai_two_freq
      @ai_two_freq ||= yield_self do
        unless @list.empty?
          @ai_two_count.fdiv(@list.size)
        end
      end
    end

    def attributes_for_model
      {
        :ai_drop_total => ai_drop_total || 0,
        :ai_wave_count => ai_wave_count || 0,
        :ai_two_freq   => ai_two_freq || 0,
      }
    end

    def to_h
      {
        :ai_drop_total   => ai_drop_total,
        :ai_ticket_count => ai_ticket_count,
        :ai_wave_count   => ai_wave_count,
        :ai_two_freq     => ai_two_freq,
      }
    end
  end
end
