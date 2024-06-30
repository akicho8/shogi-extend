module QuickScript
  module Dev
    class HelloScript < Base
      self.title = "こんにちは表示"
      self.description = "こんにちはと表示する"

      def call
        "こんにちは"
      end
    end
  end
end
