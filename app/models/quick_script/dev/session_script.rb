module QuickScript
  module Dev
    class SessionScript < Base
      self.title = "セッションID"
      self.description = "session.id.to_s"

      def call
        controller.try { session.id.to_s }
      end
    end
  end
end
