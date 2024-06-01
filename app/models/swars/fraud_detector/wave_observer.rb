module Swars
  module FraudDetector
    class WaveObserver < Observer
      class << self
        def used?(...)
          parse(...).used?
        end
      end

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
      attr_reader :drop_total

      # 棋神チケットを使い始めた回数 (重要)
      # 最初の山の数でしかないため、チケット消費量とは異なる
      #
      #  3122        → 0
      #  31222       → 1
      #  31222 22222 → 1
      #  31222 31222 → 2
      #
      # これが 1 以上で棋神確定。
      attr_reader :wave_count

      def initialize
        @mode = :idol
        @two_found = 0
        @drop_count = 0
      end

      def update(v)
        if v >= FIRST_TRIGGER_GTEQ
          @mode = :maybe
        else
          case @mode
          when :maybe
            if v == ONE_SECOND
              @mode = :consecutive_two
              @two_found = 0
            else
              @mode = :idol
            end
          when :consecutive_two
            if v == TWO_SECOND
              @two_found += 1
              if @two_found == TWO_CONSECUTIVE_GTEQ
                @wave_count ||= 0
                @wave_count += 1
                @drop_total ||= 0
                @drop_total += TWO_BEFORE_VALUE + @two_found
              end
              if @two_found > TWO_CONSECUTIVE_GTEQ
                @drop_total += 1
              end
            else
              @mode = :idol
            end
          end
        end
      end

      # 棋神チケット使用回数 (デバッグ用)
      #
      # 4手指し → 1
      # 5手指し → 1
      # 6手指し → 2
      #
      def ticket_count
        if @drop_total
          @drop_total.ceildiv(HANDS_PER_TICKET)
        end
      end

      # 棋神を使ったか？
      def used?
        if @wave_count
          @wave_count >= 1
        end
      end

      # DBに入れるときは ai_ プレフィクスをつける
      def db_attributes
        {
          :ai_drop_total => drop_total || 0,
          :ai_wave_count => wave_count || 0,
        }
      end
    end
  end
end
