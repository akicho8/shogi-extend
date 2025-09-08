module Swars
  class UserKeyValidator < Validator
    class << self
      def target_name
        "将棋ウォーズのID"
      end

      # 一般 → 最大14文字
      # プロ → 制限なし (例: "Kitahama_Kensuke" は16文字)
      # したがって余裕をもって32文字としている
      def regexp
        /\b[a-zA-Z\d][a-zA-Z\d_]{2,31}\b/
      end
    end
  end
end
