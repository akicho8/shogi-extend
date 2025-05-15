# rails r QuickScript::Swars::SprintWinRateScript.new.cache_write
module QuickScript
  module Swars
    class BasicStatScript < Base
      self.title = "旧URL対応"
      self.description = ""
      self.qs_invisible = true

      def call
        redirect_to "/lab/swars/rule-wise-win-rate"
      end
    end
  end
end
