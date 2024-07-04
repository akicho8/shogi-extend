module QuickScript
  module Dev
    class FlashScript < Base
      self.title = "flash"
      self.description = "本文には含めない一時的なメッセージを表示する"

      def call
        flash[:notice] = "(notice)"
        flash[:alert] = "(alert)"
      end
    end
  end
end
