module QuickScript
  module Swars
    class BasicStatScript < Base
      self.title = "新URLに飛ぶ"
      self.description = "/lab/swars/basic-stat から /lab/swars/rule-wise-win-rate にリダイレクトする"
      self.qs_invisible = true

      def call
        redirect_to "/lab/swars/rule-wise-win-rate"
      end
    end
  end
end
