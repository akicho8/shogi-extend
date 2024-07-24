module QuickScript
  module Account
    class KentoProDestroyScript < Base
      self.title = "KENTO Pro 解約"
      self.description = "KENTO Pro を解約する"

      def call
        { _autolink: "SHOGI-EXTEND (このサイト) と、KENTO は異なるため、KENTO Pro を解約する場合は https://www.kento-shogi.com/ に向かってください。" }
      end
    end
  end
end
