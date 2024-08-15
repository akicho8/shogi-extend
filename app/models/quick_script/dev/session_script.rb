module QuickScript
  module Dev
    class SessionScript < Base
      self.title = "セッション確認"
      self.description = "セッションの内容を確認する"

      def call
        session
      end
    end
  end
end
