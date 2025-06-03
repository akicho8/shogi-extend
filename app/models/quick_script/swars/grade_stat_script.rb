module QuickScript
  module Swars
    class GradeStatScript < Base
      self.title = "新URLに飛ぶ"
      self.description = "/lab/swars/grade-stat から新しいURLにリダイレクトする"
      self.qs_invisible = true

      def call
        redirect_to "/lab/swars/standard-score"
      end
    end
  end
end
