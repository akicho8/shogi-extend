# 時間の使い方を解析する

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
# https://www.shogi-extend.com/swars/search?query=Marina777%20%E6%89%8B%E6%95%B0%3A%3E%3D80

# 参考
# https://www.shogi-extend.com/swars/search?query=bsplive%20%E5%8B%9D%E6%95%97%3A%E8%B2%A0%E3%81%91%20%E7%9B%B8%E6%89%8B%E3%81%AE%E6%A3%8B%E5%8A%9B%3A%E4%B9%9D%E6%AE%B5%20%E5%AF%BE%E5%B1%80%E3%83%A2%E3%83%BC%E3%83%89%3A%E9%87%8E%E8%89%AF

module Swars
  module AiCop
    class Analyzer
      class << self
        def analyze(...)
          new(...).tap(&:analyze)
        end

        def test(...)
          analyze(...).to_h
        end
      end

      attr_reader :list

      def initialize(list)
        @list = list

        @observers = []
        @observers << TwoObserver.new
        @observers << WaveObserver.new
        @observers << NtmObserver.new
        @observers << GearObserver.new
      end

      def analyze
        @list.each do |v|
          @observers.each do |e|
            e.update(v)
          end
        end
      end

      def attributes_for_model
        @observers.each_with_object({}) do |e, m|
          m.update(e.attributes_for_model)
        end
      end

      def to_h
        attributes_for_model
      end
    end
  end
end
