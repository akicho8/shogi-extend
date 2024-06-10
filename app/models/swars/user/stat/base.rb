# frozen-string-literal: true

module Swars
  module User::Stat
    class Base
      include Assertion

      def initialize(stat)
        @stat = stat
      end
    end
  end
end
