module Swars
  module FraudDetector
    class TwoObserver < Observer
      TWO = 2

      attr_reader :count

      def initialize
        @count = 0
        @all = 0
      end

      def db_attributes
        {
          :ai_two_freq => freq || 0,
        }
      end

      def update(value)
        if value == TWO
          @count += 1
        end
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
