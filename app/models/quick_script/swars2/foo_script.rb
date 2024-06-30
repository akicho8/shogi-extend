module QuickScript
  module Swars2
    class FooScript < Base
      self.title = name

      def call
        __FILE__
      end
    end
  end
end
