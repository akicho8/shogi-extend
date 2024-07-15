module QuickScript
  module Chore
    class StatusCodeScript < Base
      self.title = "ステイタスコード"
      self.description = "指定のステイタスコードを返す"

      def call
        status_code
      end
    end
  end
end
