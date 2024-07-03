module QuickScript
  module Dev
    class PostScript < Base
      self.title = "こんにちは表示"
      self.description = "こんにちはと表示する"

      def call
        "こんにちは"
      end
      
      
    end
  end
end
