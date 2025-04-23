module QuickScript
  module Swars
    class SearchScript < Base
      self.title = "将棋ウォーズ棋譜検索"
      self.description = "将棋ウォーズ棋譜検索に飛ぶ"
      self.qs_invisible = !Rails.env.local?

      def call
        redirect_to "/swars/search"
      end
    end
  end
end
