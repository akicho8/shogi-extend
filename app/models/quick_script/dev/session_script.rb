module QuickScript
  module Dev
    class SessionScript < Base
      self.title = "セッションID"
      self.description = "session.id.to_s"

      def call
        controller.session.id.to_s
      end
    end
  end
end
