# 2が連続で出てくる個数の最大を求める
#
# 2が4つ連続で出たタイミングで次以降に出てくる1を1回2と見なす
#
# - 2222   → 4個
# - 22221  → 5個
# - 222212 → 6個
#
# ~/src/#!/usr/bin/env ruby
#!/usr/local/var/rbenv/versions/3.2.1/bin/rubyogi-extend/experiment/swars/ai_cop/noizy_two_max.rb
#
module Swars
  module AiCop
    class NoizyTwoMax
      ONE      = 1
      TWO      = 2
      INTERVAL = 5

      class << self
        def from(list)
          object = new
          list.each { |e| object.update(e) }
          object.max
        end
      end

      attr_reader :max

      def initialize
        @mode = :idol
        @max = 0
      end

      def update(value)
        if @mode == :idol
          if value == TWO
            @mode = :active
            @count = 0
            @life = 1
            @two_count = 0
          end
        end
        if @mode == :active
          case value
          when TWO
            count_update
            @two_count += 1
            if @two_count == INTERVAL - 1 # 4 個ごとに 1 ライフ得る
              @two_count = 0
              @life += 1
            end
          when ONE
            if @before == ONE
              @mode = :idol # 2連続はだめ
            else
              @life -= 1        # 1 が来たら 1 ライフ減る
              if @life <= 0
                @mode = :idol   # 1 の方が多くなった場合ライフが尽きてリセット
              else
                count_update    # 1 でも 2 としてカウントする
              end
            end
          else
            @mode = :idol       # 2, 1 以外の値が来たら即リセット
          end
        end
        @before = value
      end

      def count_update
        @count += 1
        if @max < @count
          @max = @count
        end
      end
    end
  end
end
