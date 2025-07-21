module QuickScript
  module Admin
    class SwarsAgentScript < Base
      self.title = "指定のウォーズIDのマイページの情報"
      self.description = "実験用"

      def call
        ::Swars::Agent::MyPage.new(user_key: "testarossa00").rule_grade_list
      end
    end
  end
end
