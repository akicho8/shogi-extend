# frozen-string-literal: true

module Swars
  module User::Stat
    module Helper
      def map_range(value, a, b, c = 0.0, d = 1.0)
        if a == b
          raise ArgumentError, "a and b must not be equal"
        end
        ratio = (value - a).to_f / (b - a)
        c + ratio * (d - c)
      end
    end
  end
end
