# frozen-string-literal: true

module Swars
  module User::Stat
    class Base
      include Assertion
      include Helper

      delegate *[
        :badge_debug,
      ], to: :stat

      def initialize(stat)
        @stat = stat
      end
    end
  end
end
