module QuickScript
  module Group1
    class HelloScript < Base
      self.title = "こんにちは表示"
      self.description = "こんにちはと表示する"

      def call
        "こんにちは"
      end
    end
  end
end
