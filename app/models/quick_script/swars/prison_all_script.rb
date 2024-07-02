module QuickScript
  module Swars
    class PrisonAllScript < Base
      self.title = "将棋ウォーズ囚人一覧"
      self.description = "アルファベット順ですべてのIDを表示する"

      def call
        av = []
        ::Swars::User.ban_only.in_batches do |group|
          av += group.pluck(:user_key)
        end
        { _v_text: av.sort.join(" ") }
      end
    end
  end
end
