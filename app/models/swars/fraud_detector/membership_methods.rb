module Swars
  module FraudDetector
    concern :MembershipMethods do
      included do
        scope :fraud_only, -> { Judgement.fraud_only(all) } # 棋神を使ったレコードのみ
      end

      # 棋神を使ったか？
      def fraud?
        Judgement.fraud?(self)
      end
    end
  end
end
