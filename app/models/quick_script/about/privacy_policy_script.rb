module QuickScript
  module About
    class PrivacyPolicyScript < Base
      self.title = "プライバシーポリシー"
      self.description = "プライバシーポリシーを表示する"

      def call
        "個人情報保護法を遵守すると共に適切な取扱い及び保護に努めます。"
      end
    end
  end
end
