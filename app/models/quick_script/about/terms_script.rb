module QuickScript
  module About
    class TermsScript < Base
      self.title = "サービス利用規約"
      self.description = "サービス利用規約を表示する"

      def call
        "個人情報保護法を遵守すると共に適切な取扱い及び保護に努めます。"
      end
    end
  end
end
