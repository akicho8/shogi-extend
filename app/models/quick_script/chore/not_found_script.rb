module QuickScript
  module Chore
    class NotFoundScript < Base
      self.title = "Not Found"
      self.description = "ページが見つかりません"

      def call
        description
      end
    end
  end
end
