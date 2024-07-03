module QuickScript
  module Dev
    class ErrorScript < Base
      self.title = "例外表示"

      def call
        1 / 0
      end
    end
  end
end
