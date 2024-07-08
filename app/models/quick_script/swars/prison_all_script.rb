module QuickScript
  module Swars
    class PrisonAllScript < Base
      self.title = "将棋ウォーズ囚人一覧"
      self.description = "すべてのユーザーをアルファベット順で表示する"

      def call
        av = []
        ::Swars::User.ban_only.in_batches do |group|
          av += group.pluck(:user_key)
        end
        { _v_text: av.sort.join(" "), class: "is_word_break_off" }
      end
    end
  end
end
