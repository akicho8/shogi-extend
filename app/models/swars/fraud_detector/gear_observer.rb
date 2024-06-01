# 121 を計測する
#
# - 121   → 1個
# - 12121 → 2個
#
module Swars
  module FraudDetector
    class GearObserver < Observer
      ONE = 1
      TWO = 2

      class << self
        def count(...)
          parse(...).count
        end

        def freq(...)
          parse(...).freq
        end
      end

      attr_reader :count

      def initialize
        @all = 0
        @count = 0
        @before = nil
        @before_before = nil
      end

      def db_attributes
        {
          :ai_gear_freq => freq || 0,
        }
      end

      def update(value)
        if value == ONE && @before == TWO && @before_before == ONE
          @count += 1
        end
        @before_before = @before
        @before = value
        @all += 1
      end

      def freq
        if @all.positive?
          @count.fdiv(@all)
        end
      end
    end
  end
end
